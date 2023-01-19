//
//  SettingViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/12.
//

import UIKit
import SnapKit
import UserNotifications

class SettingViewController: UIViewController {
//MARK: - Properties
    private let center = UNUserNotificationCenter.current()
    
    private let settingLabel = UILabel()
    
    private lazy var settingSwich : UISwitch = {
        let swich = UISwitch()
        swich.addTarget(self, action: #selector(swichPressed(_:)), for: .valueChanged)
        
        center.getNotificationSettings { settings in
            switch settings.alertSetting{
            case .enabled:
                DispatchQueue.main.async {
                    swich.isOn = true
                }
            default:
                DispatchQueue.main.async {
                    swich.isOn = false
                }
            }
        }
        return swich
    }()
    
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        viewChange()
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "설정"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func viewChange(){
        view.backgroundColor = .white
        
        view.addSubview(settingLabel)
        settingLabel.text = "알림설정"
        settingLabel.font = UIFont(name: "EF_Diary", size: 25)
        settingLabel.textColor = .black
        settingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets).inset(150)
            make.left.equalTo(view).inset(30)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        view.addSubview(settingSwich)
        settingSwich.snp.makeConstraints { make in
            make.centerY.equalTo(settingLabel)
            make.right.equalTo(view).inset(25)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        
    }
    
//MARK: - SwichMethod

    @objc private func swichPressed(_ sender : UISwitch){
        
        if sender.isOn {
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            
        }else {
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        
        }
        
    }
   

}
