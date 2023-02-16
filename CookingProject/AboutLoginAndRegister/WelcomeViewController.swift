//
//  WelcomeViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/19.
//

import UIKit
import SnapKit
import Lottie

final class WelcomeViewController: UIViewController {
//MARK: - Properties
    final var nickName = String()
    
    private let progressBar = UIProgressView()
    private let titleLabel = UILabel()
    
    private let animationView = AnimationView(name: "finish")
    
    private lazy var goToHomeButton : UIButton = {
        let button = UIButton()
        button.setTitle("홈으로", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(goToHomeButtonPressed(_:)), for: .touchUpInside)
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
        progressBar.progress = 1
        progressBar.progressTintColor = .customSignature
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(7)
        }
        
        view.addSubview(titleLabel)
        titleLabel.text = "\(nickName)님 요리도감에 오신 걸\n환영합니다!"
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .customNavy
        titleLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 25)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(70)
        }
        
        view.addSubview(animationView)
        animationView.play()
        animationView.loopMode = .loop
        animationView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottomMargin).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        view.addSubview(goToHomeButton)
        goToHomeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
        
    }
    
    private func naviBarAppearance() {
        navigationController?.navigationBar.tintColor = .black
    }
 
    
    //MARK: - ButtonMethod
    
    @objc private func goToHomeButtonPressed(_ sender : UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
}

