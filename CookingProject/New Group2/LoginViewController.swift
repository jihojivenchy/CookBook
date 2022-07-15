//
//  HomeViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/08.
//

import UIKit

class LoginViewController : UIViewController {
    
    let IDLabel = UILabel()
    let idTextField = UITextField()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    
    let findButton = UIButton()
    let registerButton = UIButton()
    let loginButton = UIButton()
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "로그인"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        viewChange()
    }
    
    //MARK: - ViewMethod
    private func viewChange() {
        
        view.addSubview(idTextField)
        idTextField.borderStyle = .roundedRect
        idTextField.clearButtonMode = .always
        idTextField.placeholder = "아이디를 입력하세요"
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets).inset(250)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(270)
            make.height.equalTo(40)
            
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.clearButtonMode = .always
        passwordTextField.placeholder = "비밀번호를 입력하세요"
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp_bottomMargin).offset(30)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(270)
            make.height.equalTo(40)
        }
        
        view.addSubview(loginButton)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .black
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets).inset(250)
            make.right.equalTo(view).inset(10)
            make.height.width.equalTo(100)
        }
        
        view.addSubview(findButton)
        findButton.setTitle("아이디/비밀번호 찾기", for: .normal)
        findButton.setTitleColor(.black, for: .normal)
        findButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp_bottomMargin).offset(30)
            make.left.equalTo(view).inset(60)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        view.addSubview(registerButton)
        registerButton.setTitle("회원가입", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp_bottomMargin).offset(30)
            make.left.equalTo(findButton.snp_rightMargin).offset(40)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        
        
    }
    
    
}
