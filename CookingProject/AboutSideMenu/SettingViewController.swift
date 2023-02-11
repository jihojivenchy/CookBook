//
//  SettingViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/12.
//

import UIKit
import SnapKit
import UserNotifications
import Photos

final class SettingViewController: UIViewController {
//MARK: - Properties
    private let center = UNUserNotificationCenter.current()
    
    private lazy var notificationButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(notificationButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    private lazy var photoLibraryAccessButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(notificationButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //앱 환경설정에 갔다가 foreground로 돌아설 때 시점을 캐치해서 버튼 타이틀 변경.
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        naviBarAppearance()
        addSubViews()
        
        checkNotificationAccessState()
        checkPhotoAccessState()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //뷰가 사라질 때 캐치 메서드를 삭제해줘야 메모리 릭을 방지할 수 있음.
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        self.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "설정"
    }
    
    private func addSubViews(){
        view.backgroundColor = .customWhite
        
        view.addSubview(notificationButton)
        notificationButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(55)
        }
        
        view.addSubview(photoLibraryAccessButton)
        photoLibraryAccessButton.snp.makeConstraints { make in
            make.top.equalTo(notificationButton.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(55)
        }
        
    }
    
    private func checkNotificationAccessState() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                DispatchQueue.main.async {
                    self.notificationButton.setTitle("알림 ON", for: .normal)
                }
                
            }else{
                DispatchQueue.main.async {
                    self.notificationButton.setTitle("알림 OFF", for: .normal)
                }
            }
        }
    }
    
    private func checkPhotoAccessState() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            print("허용")
            
            DispatchQueue.main.async {
                self.photoLibraryAccessButton.setTitle("앨범 접근 권한 ON", for: .normal)
            }
            
            break
        case .denied:
            print("거부")
            
            DispatchQueue.main.async {
                self.photoLibraryAccessButton.setTitle("앨범 접근 권한 OFF", for: .normal)
            }
            
            break
        case .notDetermined:
            print("결정하지 못함")
            
            DispatchQueue.main.async {
                self.photoLibraryAccessButton.setTitle("앨범 접근 권한 OFF", for: .normal)
            }
            
            break
        case .restricted:
            print("통제불가 항목 -> 시스템 설정확인")
            
            DispatchQueue.main.async {
                self.photoLibraryAccessButton.setTitle("앨범 접근 권한 OFF(시스템 설정 확인)", for: .normal)
            }
            
            break
        case .limited:
            print("한계?")
            
            break
        @unknown default:
            print("뭔지 모르는 상태")
            
            DispatchQueue.main.async {
                self.photoLibraryAccessButton.setTitle("앨범 접근 권한 OFF(시스템 설정 확인)", for: .normal)
            }
            
            break
        }
    }
    
    
//MARK: - ButtonMethod
    @objc private func notificationButtonPressed(_ sender : UIButton){
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        
    }

    @objc func applicationWillEnterForeground() {
        checkNotificationAccessState()
        checkPhotoAccessState()
    }
    

}
