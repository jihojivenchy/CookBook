//
//  ProfileViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit
import FirebaseFirestore
import Firebase

final class ProfileViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    final var userInformationData : UserInformationData = .init(name: "", email: "", login: "")
    
    private let nickNameLabel = UILabel()
    private lazy var nickNameTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.clearButtonMode = .always
        tf.tintColor = .black
        tf.textColor = .black
        tf.font = .boldSystemFont(ofSize: 17)
        tf.delegate = self
        
        return tf
    }()
    
    private let emailLabel = UILabel()
    private lazy var emailTextField : UITextField = {
        let tf = UITextField()
        tf.isUserInteractionEnabled = false
        tf.backgroundColor = .clear
        tf.tintColor = .black
        tf.textColor = .black
        tf.font = .boldSystemFont(ofSize: 17)
        tf.delegate = self
        
        return tf
    }()
    
    private let loginLabel = UILabel()
    private lazy var loginTextField : UITextField = {
        let tf = UITextField()
        tf.isUserInteractionEnabled = false
        tf.backgroundColor = .clear
        tf.tintColor = .black
        tf.textColor = .black
        tf.font = .boldSystemFont(ofSize: 17)
        tf.delegate = self
        
        return tf
    }()
    
    private let userImageView = UIImageView()
    
    private lazy var saveButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonPressed(_:)))
        
        return sb
    }()
    
//MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        naviBarAppearance()
        viewChange()
        setUserInfomationData()
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        
        navigationController?.navigationBar.tintColor = .customSignature
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func viewChange() {
        
        view.backgroundColor = .white
        
        view.addSubview(userImageView)
        userImageView.tintColor = .customSignature
        userImageView.image = UIImage(systemName: "person.circle")
        userImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.height.equalTo(70)
        }
        
        view.addSubview(nickNameLabel)
        nickNameLabel.text = "닉네임"
        nickNameLabel.textColor = .customSignature
        nickNameLabel.font = .boldSystemFont(ofSize: 14)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp_bottomMargin).offset(30)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        view.addSubview(nickNameTextField)
        textFieldBorderCustom(target: nickNameTextField)
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp_bottomMargin)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(emailLabel)
        emailLabel.text = "이메일"
        emailLabel.textColor = .customSignature
        emailLabel.font = .boldSystemFont(ofSize: 14)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp_bottomMargin).offset(30)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        view.addSubview(emailTextField)
        textFieldBorderCustom(target: emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp_bottomMargin)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(loginLabel)
        loginLabel.text = "로그인 정보"
        loginLabel.textColor = .customSignature
        loginLabel.font = .boldSystemFont(ofSize: 14)
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp_bottomMargin).offset(30)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        view.addSubview(loginTextField)
        textFieldBorderCustom(target: loginTextField)
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp_bottomMargin)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
    }
    
    private func textFieldBorderCustom(target : UITextField) {
        
        let border = UIView()
        border.backgroundColor = .customSignature
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: nickNameTextField.frame.width, height: 2)
        target.addSubview(border)
        //특정 border line
    }
    
    private func setUserInfomationData() {
        self.nickNameTextField.text = userInformationData.name
        self.emailTextField.text = userInformationData.email
        
        switch userInformationData.login {
        case "kakao":
            self.loginTextField.text = "카카오 로그인"
        case "naver":
            self.loginTextField.text = "네이버 로그인"
        case "appleLogin":
            self.loginTextField.text = "애플 로그인"
        default:
            self.loginTextField.text = "이메일 로그인"
            
        }
    }
    
//MARK: - ButtonMethod
    @objc private func saveButtonPressed(_ sender : UIBarButtonItem) {
        
    }
}

//MARK: - Extension
extension ProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if let char = string.cString(using: String.Encoding.utf8) {
//            let isBackSpace = strcmp(char, "\\b")
//            if isBackSpace == -92 {
//                return true
//            }
//        }//백스페이스는 감지할 수 있도록 하는 코드
//
//        guard let text = textField.text else {return false}
//
//        // 제한 글자수 이상을 입력한 이후에는 작동이멈춤.
//        if text.count > 8 {
//            return false
//        }
//
//        return true
//    }
}
