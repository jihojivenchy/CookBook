//
//  HomeViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/08.
//

import UIKit
import SnapKit
import Firebase


class LoginViewController : UIViewController {
    //MARK: - Properties
    private var loginType = ""
    
    private let IDLabel = UILabel()
    private lazy var idTextField : UITextField = {
        let it = UITextField()
        it.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) //여백주기
        it.leftViewMode = .always
        it.isEnabled = true
        it.backgroundColor = .white
        it.layer.borderWidth = 1
        it.clearButtonMode = .always
        it.layer.cornerRadius = 10
        it.attributedPlaceholder = NSAttributedString(string: "아이디를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray ?? UIColor.lightGray])
        it.layer.borderColor = UIColor.customGray?.cgColor
        it.textColor = .black
        
        return it
    }()
    
    private let passwordLabel = UILabel()
    private lazy var passwordTextField : UITextField = {
        let pt = UITextField()
        pt.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        pt.leftViewMode = .always
        pt.isEnabled = true
        pt.isSecureTextEntry = true
        pt.backgroundColor = .white
        pt.layer.borderWidth = 1
        pt.clearButtonMode = .always
        pt.layer.cornerRadius = 10
        pt.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray ?? UIColor.lightGray])
        pt.layer.borderColor = UIColor.customGray?.cgColor
        pt.textColor = .black
        
        return pt
    }()
    
    private let registerLabel = UILabel()
    private let registerButton = UIButton()
    private lazy var loginButton : UIButton = {
        let lb = UIButton()
        lb.setTitle("Login", for: .normal)
        lb.backgroundColor = .customPink
        lb.setTitleColor(.white, for: .normal)
        lb.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
        return lb
    }()
    
    private lazy var indicatorView : UIActivityIndicatorView = {
       let ia = UIActivityIndicatorView()
        ia.hidesWhenStopped = true
        ia.style = .large
        
        return ia
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
       
        if Auth.auth().currentUser != nil{
            idTextField.text = "현재 로그인 상태입니다."
            passwordTextField.text = "현재 로그인 상태입니다."
            idTextField.isEnabled = false
            passwordTextField.isEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        
        viewChange()
        registerButton.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.title = "로그인"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func viewChange() {
        view.backgroundColor = .white
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets).inset(250)
            make.right.equalTo(view).inset(10)
            make.height.width.equalTo(100)
        }
        
        view.addSubview(idTextField)
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets).inset(250)
            make.left.equalToSuperview().inset(10)
            make.right.equalTo(loginButton.snp_leftMargin).offset(-20)
            make.height.equalTo(40)
            
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp_bottomMargin).offset(30)
            make.left.equalToSuperview().inset(10)
            make.right.equalTo(loginButton.snp_leftMargin).offset(-20)
            make.height.equalTo(40)
        }
        
        view.addSubview(registerLabel)
        registerLabel.text = "회원이아니신가요? ->"
        registerLabel.textColor = .lightGray
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp_bottomMargin).offset(30)
            make.left.equalTo(view).inset(80)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        view.addSubview(registerButton)
        registerButton.setTitle("회원가입", for: .normal)
        registerButton.setTitleColor(.customPink, for: .normal)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp_bottomMargin).offset(30)
            make.left.equalTo(registerLabel.snp_rightMargin).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(100)
        }
        
    }
    
    private func loginErrorAlert() {
        let alert = UIAlertController(title: "로그인오류", message: "아이디 혹은 비밀번호를 확인하세요", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func registerButtonPressed(_ sender : UIButton) {
        performSegue(withIdentifier: "goToJoin", sender: self)
    }
    
    @objc private func loginButtonPressed(_ sender : UIButton) {
        self.indicatorView.startAnimating()
        if let email = idTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e)
                    self.indicatorView.stopAnimating()
                    self.loginErrorAlert()
                    
                }else{
                    self.indicatorView.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
        
    }
    
}
