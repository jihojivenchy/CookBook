//
//  WriteEmailViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/19.
//

import UIKit
import SnapKit

final class WriteEmailViewController: UIViewController {
//MARK: - Properties
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let progressBar = UIProgressView()
    private let titleLabel = UILabel()
    
    private let emailTextField = UITextField()
    
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    final var nickName = String()
    
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
        progressBar.progress = 0.5
        progressBar.progressTintColor = .customSignature
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(7)
        }
        
        view.addSubview(titleLabel)
        titleLabel.text = "로그인에 사용할 아이디를 \n작성해주세요"
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .customNavy
        titleLabel.font = UIFont(name: KeyWord.CustomFont, size: 25)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(90)
        }
        
        view.addSubview(emailTextField)
        textFieldBorderCustom()
        emailTextField.tintColor = .black
        emailTextField.returnKeyType = .done
        emailTextField.clearButtonMode = .always
        emailTextField.placeholder = "아이디(이메일 형식)를 작성해주세요"
        emailTextField.font = .systemFont(ofSize: 16)
        emailTextField.delegate = self
        emailTextField.textColor = .black
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
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
    
    private func textFieldBorderCustom() {
        
        let border = UIView()
        border.backgroundColor = .lightGray
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: emailTextField.frame.width, height: 2)
        emailTextField.addSubview(border)
        //특정 border line
    }
    
    private func checkEmailState() -> Bool {
        
        if let email = emailTextField.text {
            
            if email.contains("@") { //이메일형식인지 확인
                return true
                
            }else{
                return false
            }

        }else{
            return false
        }
    }//이메일 형식인지 확인
    
//MARK: - ButtonMethod
    
    @objc private func nextButtonPressed(_ sender : UIButton){
        guard let writedEmail = emailTextField.text else{return}
        
        if checkEmailState() {
            let vc = WritePasswordViewController()
            
            vc.email = writedEmail
            vc.nickName = self.nickName
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            CustomAlert.show(title: "오류", subMessage: "양식에 맞게 작성해주세요.")
        }
        
    }
}

//MARK: - Extension
extension WriteEmailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
}
