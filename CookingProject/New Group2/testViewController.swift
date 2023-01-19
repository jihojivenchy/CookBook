////
////  SocialLoginViewController.swift
////  CookingProject
////
////  Created by 엄지호 on 2023/01/16.
////
//
//import UIKit
//import SnapKit
//
//final class testViewController: UIViewController {
////MARK: - Properties
//    private let titleLabel = UILabel()
//    
//    private lazy var kakaoButton : UIButton = {
//        let button = UIButton()
//        button.setTitle("카카오로 로그인", for: .normal)
//        button.setTitleColor(.black.withAlphaComponent(0.85), for: .normal)
//        button.setImage(UIImage(named: "kakao"), for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 20)
//        button.backgroundColor = .kakaoColor
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 12
//        
//        return button
//    }()
//    
//    private lazy var naverButton : UIButton = {
//        let button = UIButton()
//        button.setTitle("네이버로 로그인", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.setImage(UIImage(named: "naver"), for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 20)
//        button.backgroundColor = .naverColor
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 12
//        
//        return button
//    }()
//    
//    private lazy var appleButton : UIButton = {
//        let button = UIButton()
//        button.setTitle("Apple로 로그인", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.setImage(UIImage(named: "apple"), for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 20)
//        button.backgroundColor = .black
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 12
//        
//        return button
//    }()
//    
//    private lazy var emailButton : UIButton = {
//        let button = UIButton()
//        button.setTitle("이메일로 로그인", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 20)
//        button.backgroundColor = .customSignature
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 12
//        
//        return button
//    }()
//    
//    //MARK: - LifeCycle
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        tabBarController?.tabBar.isHidden = true
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        addSubViews()
//        naviBarAppearance()
//        
//    }
//    
//    private func naviBarAppearance() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        navigationItem.standardAppearance = appearance
//        navigationItem.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.tintColor = .black
//        
//        //        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//    
//    
//    private func addSubViews() {
//        
//        view.backgroundColor = .white
//        
//        view.addSubview(titleLabel)
//        titleLabel.text = "요리도감"
//        titleLabel.textColor = .customSignature
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont(name: "ChosunCentennial", size: 35)
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
//            make.left.right.equalToSuperview().inset(30)
//            make.height.equalTo(40)
//        }
//        
//        view.addSubview(kakaoButton)
//        kakaoButton.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp_bottomMargin).offset(100)
//            make.left.right.equalToSuperview().inset(35)
//            make.height.equalTo(60)
//        }
//        
//        view.addSubview(naverButton)
//        naverButton.snp.makeConstraints { make in
//            make.top.equalTo(kakaoButton.snp_bottomMargin).offset(20)
//            make.left.right.equalToSuperview().inset(35)
//            make.height.equalTo(60)
//        }
//        
//        view.addSubview(appleButton)
//        appleButton.snp.makeConstraints { make in
//            make.top.equalTo(naverButton.snp_bottomMargin).offset(20)
//            make.left.right.equalToSuperview().inset(35)
//            make.height.equalTo(60)
//        }
//        
//        view.addSubview(emailButton)
//        emailButton.snp.makeConstraints { make in
//            make.top.equalTo(appleButton.snp_bottomMargin).offset(20)
//            make.left.right.equalToSuperview().inset(35)
//            make.height.equalTo(60)
//        }
//    }
//    
//    
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
//        self.view.endEditing(true)
//    }
//    
//    
//    
//}
//
////MARK: - Extension
