//
//  CustomSplashViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/16.
//

import UIKit
import SnapKit
import Lottie

final class CustomSplashViewController: UIViewController {
//MARK: - Properties
    private let titleLabel = UILabel()
    private let animationView = AnimationView(name: "cookBook")
    
    private let stackView = UIStackView()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        goToMainView()
    }
    
    
    private func addSubViews() {
        
        view.backgroundColor = .customWhite
        
        animationView.play()
        animationView.loopMode = .loop
        animationView.tintColor = .customNavy
        animationView.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
        
        titleLabel.text = "요리도감"
        titleLabel.textColor = .customNavy
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: KeyWord.CustomFont, size: 35)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        view.addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(animationView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(350)
        }
        
    }
    
    private func goToMainView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let vc = storyBoard.instantiateViewController(identifier: "TabBar") as? CustomTabBarController else{return print("error")}
            
            let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            scene?.changeRootView(vc: vc)
        })
    }
    
    
    
    
//MARK: - ButtonMethod
    
  
    
    
}

//MARK: - Extension
