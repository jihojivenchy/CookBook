//
//  ReportViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/19.
//

import UIKit
import SnapKit

class ReportViewController: UIViewController {
//MARK: - Properties
    
    private let backgroundView = UIView()
    
    private let reportTextView = UITextView()
    
    private lazy var reportButton : UIButton = {
        let rb = UIButton()
        rb.setTitle("고객센터 바로가기", for: .normal)
        rb.backgroundColor = .customPink
        rb.tintColor = .white
        rb.addTarget(self, action: #selector(reportButtonPressed(_:)), for: .touchUpInside)
        
        return rb
    }()
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewChange()
        naviBarAppearance()
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.title = "신고하기"
    }
    
    private func viewChange() {
        
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = .white
        backgroundView.layer.borderColor = UIColor.customPink?.cgColor
        backgroundView.layer.borderWidth = 1
        backgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.right.equalTo(view).inset(10)
            make.height.equalTo(430)
        }
        
        backgroundView.addSubview(reportTextView)
        reportTextView.text = "요리도감 고객센터는 오픈 카카오톡으로 구성되어 있습니다. \n관리자를 향한 욕설과 비방은 자제 부탁드립니다. 감사합니다. \n\n채팅방 이름: \"요리도감 고객센터\" \n참여코드: \"cook\""
        reportTextView.textColor = .black
        reportTextView.isEditable = false
        reportTextView.font = .systemFont(ofSize: 20)
        reportTextView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).inset(20)
            make.right.left.equalTo(backgroundView).inset(20)
            make.height.equalTo(300)
        }
        
        
        backgroundView.addSubview(reportButton)
        reportButton.snp.makeConstraints { make in
            make.bottom.equalTo(backgroundView).inset(10)
            make.right.left.equalTo(backgroundView).inset(20)
            make.height.equalTo(45)
        }
        
    }
    
    @objc private func reportButtonPressed(_ sender : UIButton) {
        let centerURL = "https://open.kakao.com/o/skUiDAwe"
        let kakaoTalkURL = NSURL(string: centerURL)
        
        if UIApplication.shared.canOpenURL(kakaoTalkURL! as URL){
            UIApplication.shared.open(kakaoTalkURL! as URL)
        }else{
            failToCenterAlert()
        }
        
    }
    
    private func failToCenterAlert() {
        let alert = UIAlertController(title: "현재 접속이 불가능합니다.", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}
