//
//  FindPasswordViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/19.
//

import UIKit
import SnapKit
import FirebaseAuth

final class FindPasswordViewController: UIViewController {
//MARK: - Properties
    
    private let titleLabel = UILabel()
    
    private let emailTextField = UITextField()
    
    private lazy var sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
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
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.text = "비밀번호 재 설정 메일을 받을 \n아이디(이메일)를 입력해주세요."
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(90)
        }
        
        view.addSubview(emailTextField)
        textFieldBorderCustom()
        emailTextField.tintColor = .black
        emailTextField.returnKeyType = .done
        emailTextField.clearButtonMode = .always
        emailTextField.placeholder = "아이디(이메일)를 작성해주세요"
        emailTextField.font = .systemFont(ofSize: 16)
        emailTextField.delegate = self
        emailTextField.textColor = .black
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp_bottomMargin).offset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
    }
    
    private func naviBarAppearance() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
    }
    
    private func textFieldBorderCustom() {
        
        let border = UIView()
        border.backgroundColor = .lightGray
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: emailTextField.frame.width, height: 2)
        emailTextField.addSubview(border)
        //특정 border line
    }
    
//MARK: - ButtonMethod
    
    @objc private func sendButtonPressed(_ sender : UIButton){
        guard let email = emailTextField.text else{return}
        
        if email != "" {
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let e = error {
                    print("Error 비밀번호 재설정 이메일 보내기 실패 : \(e)")
                    
                    DispatchQueue.main.async {
                        CustomAlert.show(title: "오류", subMessage: "양식에 맞게 작성해주세요.")
                    }
                    
                }else{
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            
        }else{
            DispatchQueue.main.async {
                CustomAlert.show(title: "오류", subMessage: "양식에 맞게 작성해주세요.")
            }
            
        }
        
    }
}

//MARK: - Extension
extension FindPasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
}
