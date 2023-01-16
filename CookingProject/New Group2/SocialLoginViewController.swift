//
//  SocialLoginViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/16.
//

import UIKit
import SnapKit

final class SocialLoginViewController: UIViewController {
//MARK: - Properties
    private let titleLabel = UILabel()
    
    private let backGroundView = UIView()
    private let idTextField = UITextField()
    private let pwTextField = UITextField()
    
    
    private lazy var findPWButton : UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setUnderLine()    //버튼에 언더라인 추가 (extension)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        
        return button
    }()
    
    private lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let registerLabel = UILabel()
    private lazy var registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.customSignature, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.setUnderLine()
        
        return button
    }()
    
    let stackView = UIStackView()
    
    private lazy var appleButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "apple"), for: .normal)
        
        return button
    }()
    
    private lazy var kakaoButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "kakao"), for: .normal)
        
        return button
    }()
    
    private lazy var naverButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "naver"), for: .normal)
        
        return button
    }()
    
    
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        naviBarAppearance()
        
    }
    
    private func naviBarAppearance() {
        
        navigationController?.navigationBar.tintColor = .black
    }
    
   
    private func addSubViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.text = "요리도감"
        titleLabel.textColor = .customSignature
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "ChosunCentennial", size: 35)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        view.addSubview(backGroundView)
        backGroundView.backgroundColor = .white
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 7
        backGroundView.layer.borderColor = UIColor.darkGray.cgColor
        backGroundView.layer.borderWidth = 1
        backGroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(120)
        }
        
        backGroundView.addSubview(idTextField)
        idTextField.placeholder = "아이디를 입력해주세요."
        idTextField.textColor = .black
        idTextField.tintColor = .black
        idTextField.clearButtonMode = .whileEditing
        idTextField.font = .boldSystemFont(ofSize: 16)
        idTextField.backgroundColor = .clear
        idTextField.clipsToBounds = true
        idTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(17)
            make.height.equalTo(55)
        }
        
        backGroundView.addSubview(pwTextField)
        pwTextField.placeholder = "비밀번호를 입력해주세요."
        pwTextField.font = .boldSystemFont(ofSize: 16)
        pwTextField.backgroundColor = .clear
        pwTextField.textColor = .black
        pwTextField.tintColor = .black
        pwTextField.clearButtonMode = .whileEditing
        addTopBorder()
        pwTextField.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(17)
            make.height.equalTo(55)
        }
        
        view.addSubview(findPWButton)
        findPWButton.snp.makeConstraints { make in
            make.top.equalTo(backGroundView.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(findPWButton.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        kakaoButton.setBackgroundImage(UIImage(named: "kakao"), for: .normal)
        kakaoButton.addTarget(self, action: #selector(kakaoLoginPressed(_:)), for: .touchUpInside)
        kakaoButton.snp.makeConstraints { make in
            make.width.height.equalTo(45)
        }
        
        naverButton.setBackgroundImage(UIImage(named: "naver"), for: .normal)
        naverButton.addTarget(self, action: #selector(naverLoginPressed(_:)), for: .touchUpInside)
        naverButton.snp.makeConstraints { make in
            make.width.height.equalTo(45)
        }
        
        
        appleButton.setBackgroundImage(UIImage(named: "apple"), for: .normal)
        appleButton.addTarget(self, action: #selector(appleLoginPressed(_:)), for: .touchUpInside)
        appleButton.snp.makeConstraints { make in
            make.width.height.equalTo(45)
        }
        
        view.addSubview(stackView)
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.addArrangedSubview(kakaoButton)
        stackView.addArrangedSubview(naverButton)
        stackView.addArrangedSubview(appleButton)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp_bottomMargin).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        view.addSubview(registerLabel)
        registerLabel.text = "아직 계정이 없으신가요?"
        registerLabel.textColor = .darkGray
        registerLabel.font = .boldSystemFont(ofSize: 15)
        registerLabel.textAlignment = .center
        registerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(20)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp_bottomMargin).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
    }

    private func addTopBorder() {
        let border = UIView()
        border.backgroundColor = .lightGray
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: pwTextField.frame.width, height: 1)
        pwTextField.addSubview(border)
    }//특정 border line
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
    }
    
    
//MARK: - ButtonMethod
    
    @objc func kakaoLoginPressed(_ sender : UIButton) {

    }
    
    @objc func naverLoginPressed(_ sender : UIButton) {
        
    }
    
    @objc func appleLoginPressed(_ sender : UIButton) {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
    }
   
    
    
}

//MARK: - Extension
extension SocialLoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
