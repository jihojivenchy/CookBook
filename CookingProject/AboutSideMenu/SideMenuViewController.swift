//
//  SideMenuViewControllerViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/22.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import SCLAlertView
import NaverThirdPartyLogin
import KakaoSDKUser
import SideMenu

final class SideMenuViewController: UIViewController {
    //MARK: - Properties
    private let db = Firestore.firestore()
    final var userInformationData : UserInformationData = .init(name: "", email: "", login: "")
    final var pushDelegate : CellPushDelegate?
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private lazy var dismissButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(dismissButtonPressed(_:)))
        sb.tintColor = .customSignature
        
        return sb
    }()
    
    private let menuTableView = UITableView(frame: .zero, style: .grouped)
    
    private var menuImageArray = ["list.bullet.rectangle.portrait", "person.badge.minus", "gearshape", "message", "rectangle.portrait.and.arrow.right"]
    private var menuTitleArray = ["나의 레시피", "차단유저 관리", "설정", "피드백", "로그아웃"]
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = .customSignature
        rf.addTarget(self, action: #selector(reloadAction(_:)), for: .valueChanged)
        
        return rf
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLoginState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        naviBarAppearance()
        
        menuTableView.refreshControl = refresh
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        menuTableView.rowHeight = 70
    }
    
    //MARK: - ViewMethod
    
    private func naviBarAppearance() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = dismissButton
    }
    
    private func addSubViews() {
        view.backgroundColor = .customWhite
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 30
//        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
//        view.layer.borderColor = UIColor.customSignature?.cgColor
//        view.layer.borderWidth = 0.5
        
        view.addSubview(menuTableView)
        menuTableView.backgroundColor = .clear
        menuTableView.showsVerticalScrollIndicator = false
        menuTableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func checkLoginState() {
        if Auth.auth().currentUser != nil {
            self.menuImageArray[4] = "rectangle.portrait.and.arrow.right"
            self.menuTitleArray[4] = "로그아웃"
            
            self.menuTableView.reloadData()
        }else{
            self.menuImageArray[4] = "iphone.and.arrow.forward"
            self.menuTitleArray[4] = "로그인"
            
            self.menuTableView.reloadData()
        }
    } //login check
    
    
    @objc private func reloadAction(_ sender : UIRefreshControl) {
        menuTableView.reloadData()
        refresh.endRefreshing()
    }
    
    
//MARK: - ButtonMethod
    @objc private func dismissButtonPressed(_ sender : UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
//MARK: - DataMethod
    
}

//MARK: - Extension
extension SideMenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.menuTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath) as! SideMenuTableViewCell
        
        cell.menuImageView.image = UIImage(systemName: self.menuImageArray[indexPath.row])
        cell.menuLabel.text = self.menuTitleArray[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeaderView = SideMenuHeaderView()
        
        customHeaderView.nameLabel.text = self.userInformationData.name
        customHeaderView.emailLabel.text = self.userInformationData.email
        customHeaderView.delegate = self
        
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}

extension SideMenuViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.pushDelegate?.cellPressed(index: 0)
            self.dismiss(animated: true)
            
        }else if indexPath.row == 1 {
            self.pushDelegate?.cellPressed(index: 1)
            self.dismiss(animated: true)
            
        }else if indexPath.row == 2 {
            self.pushDelegate?.cellPressed(index: 2)
            self.dismiss(animated: true)
            
        }else if indexPath.row == 3 {
            self.pushDelegate?.cellPressed(index: 3)
            self.dismiss(animated: true)
            
        }else {
            if menuTitleArray[4] == "로그인" {
                loginOrLogout(title: "로그인", subMessage: "로그인 하시겠습니까?")
            
            }else{
                loginOrLogout(title: "로그아웃", subMessage: "로그아웃 하시겠습니까?")
            }
        }
        
        
    }
}

//MARK: - LogOutMethod
extension SideMenuViewController {
    
    private func loginOrLogout(title : String, subMessage : String) {
        let appearence = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: KeyWord.CustomFontMedium, size: 17) ?? .boldSystemFont(ofSize: 17), kTextFont: UIFont(name: KeyWord.CustomFont, size: 13) ?? .boldSystemFont(ofSize: 13), showCloseButton: false)
        let alert = SCLAlertView(appearance: appearence)
        
        alert.addButton("확인", backgroundColor: .customSignature, textColor: .white) {
            if title == "로그인" {
                self.goToLogin()
            }else{
                self.goToLogout()
            }
        }
        
        alert.addButton("취소", backgroundColor: .customSignature, textColor: .white) {
            print("취소")
        }
        
        alert.showSuccess(title,
                          subTitle: subMessage,
                          colorStyle: 0xFFB6B9,
                          colorTextButton: 0xFFFFFF)
    }
    
    private func goToLogin() {
        self.navigationController?.pushViewController(SocialLoginViewController(), animated: true)
    }
    
    private func goToLogout() {
        //유저가 로그인을 어떤 방식을 사용했는지
        switch userInformationData.login {
            
        case "kakao":
            UserApi.shared.logout { error in
                if let e = error {
                    print("Error 카카오 로그아웃 실패 : \(e)")
                }else{
                    print("카카오 로그아웃 성공")
                }
            }
            
        case "naver":
            NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken() //네이버 로그인 토큰 삭제
            
        default:
            print("외부 로그인 사용")
        }
        
        firebaseLogOut()
    }
    
    private func firebaseLogOut() {
        do {
            try Auth.auth().signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            CustomAlert.show(title: "로그아웃 실패", subMessage: "다시 실행해주세요.")
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(SocialLoginViewController(), animated: true)
        }
    }
    
}

extension SideMenuViewController : SideMenuHeaderTouchDelegate {
    func tapHeaderView() {
        if Auth.auth().currentUser != nil {
            self.pushDelegate?.cellPressed(index: 5)
            self.dismiss(animated: true)
            
        }else{
            CustomAlert.show(title: "로그인", subMessage: "로그인이 필요한 서비스입니다.")
        }
        
    }
    
}

protocol CellPushDelegate {
    func cellPressed(index : Int)
}
