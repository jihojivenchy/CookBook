//
//  WritePasswordViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/19.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class WritePasswordViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    final var email = String()
    final var nickName = String()
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let progressBar = UIProgressView()
    private let titleLabel = UILabel()
    
    private let passwordTextField = UITextField()
    private let pwCheckTextField = UITextField()
    private let checkLabel = UILabel()
    
    private lazy var registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        naviBarAppearance()
    }
    
    
    //MARK: - ViewMethod
    
    private func addSubViews() {
        view.backgroundColor = .customWhite
        
        view.addSubview(progressBar)
        progressBar.backgroundColor = .lightGray
        progressBar.progress = 0.75
        progressBar.progressTintColor = .customSignature
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(7)
        }
        
        view.addSubview(titleLabel)
        titleLabel.text = "로그인에 사용할 비밀번호를 \n작성해주세요"
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .customNavy
        titleLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 25)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
        
        view.addSubview(passwordTextField)
        textFieldBorderCustom(target: passwordTextField)
        passwordTextField.tag = 0
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tintColor = .black
        passwordTextField.returnKeyType = .done
        passwordTextField.clearButtonMode = .always
        passwordTextField.placeholder = "비밀번호(6자 이상)를 작성해주세요"
        passwordTextField.font = .systemFont(ofSize: 16)
        passwordTextField.delegate = self
        passwordTextField.textColor = .black
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
        
        view.addSubview(pwCheckTextField)
        textFieldBorderCustom(target: pwCheckTextField)
        pwCheckTextField.tag = 1
        pwCheckTextField.isSecureTextEntry = true
        pwCheckTextField.tintColor = .black
        pwCheckTextField.returnKeyType = .done
        pwCheckTextField.clearButtonMode = .always
        pwCheckTextField.placeholder = "비밀번호 확인"
        pwCheckTextField.font = .systemFont(ofSize: 16)
        pwCheckTextField.delegate = self
        pwCheckTextField.textColor = .black
        pwCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
        
        view.addSubview(checkLabel)
        checkLabel.textColor = .red
        checkLabel.font = .boldSystemFont(ofSize: 12)
        checkLabel.snp.makeConstraints { make in
            make.top.equalTo(pwCheckTextField.snp_bottomMargin).offset(18)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
    }
    
    private func naviBarAppearance() {
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
    }
    
    private func textFieldBorderCustom(target : UITextField) {
        
        let border = UIView()
        border.backgroundColor = .lightGray
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: passwordTextField.frame.width, height: 2)
        target.addSubview(border)
        //특정 border line
    }
    
//MARK: - ButtonMethod
    
    @objc private func registerButtonPressed(_ sender : UIButton){
        guard let check = checkLabel.text else{return}
        guard let password = pwCheckTextField.text else{return}
        
        if check == "비밀번호가 일치합니다." {
            CustomLoadingView.shared.startLoading(alpha: 0.5)
            self.firebaseRegister(email: self.email, password: password, nickName: self.nickName)
        }else{
            CustomAlert.show(title: "오류", subMessage: "비밀번호를 확인해주세요.")
        }
        
    }
}

//MARK: - Extension
extension WritePasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let pwText = self.passwordTextField.text else{return }
        guard let check = self.pwCheckTextField.text else{return}
        
        if pwText == check {
            if pwText == "" {
                self.checkLabel.textColor = .red
                self.checkLabel.text = "비밀번호를 입력해주세요."
            }else{
                self.checkLabel.textColor = .green
                self.checkLabel.text = "비밀번호가 일치합니다."
            }
            
        }else{
            self.checkLabel.textColor = .red
            self.checkLabel.text = "비밀번호가 일치하지 않습니다."
        }
    }
}

//MARK: - FirebaseRegister
extension WritePasswordViewController {
    
    private func firebaseRegister(email : String, password : String, nickName : String) {
        // 파이어베이스 유저 생성 (이메일로 회원가입)
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("Error 파이어베이스 회원가입 실패 \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    CustomAlert.show(title: "가입 실패", subMessage: "양식에 맞게 작성해주셨나요?")
                }
                
            } else {
                guard let userUID = result?.user.uid else{return}
                
                //유저 데이터에 로그인했던 방법과 닉네임을 저장
                self.db.collection("Users").document(userUID).setData([DataKeyWord.myName : nickName,
                                                                       "email" : email,
                                                                       "login" : "firebase"])
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    
                    let vc = WelcomeViewController()
                    vc.nickName = self.nickName
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
