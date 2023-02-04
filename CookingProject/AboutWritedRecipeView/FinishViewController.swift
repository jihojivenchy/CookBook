//
//  FinishViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/30.
//

import UIKit
import SnapKit
import Lottie

final class FinishViewController: UIViewController {
    //MARK: - Properties
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let progressBar = UIProgressView()
    private let explainLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let animationView = AnimationView(name: "chef")
    
    private lazy var goToRecipeButton : UIButton = {
        let button = UIButton()
        button.setTitle("레시피 보러가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(recipeButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    private lazy var goToHomeButton : UIButton = {
        let button = UIButton()
        button.setTitle("홈으로", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(homeButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    
    final var userName = String()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        addSubViews()
        
    }
    
    //MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func addSubViews() {
        view.backgroundColor = .customGray
        
        view.addSubview(progressBar)
        progressBar.backgroundColor = .lightGray
        progressBar.progress = 1
        progressBar.progressTintColor = .customSignature
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(7)
        }
        
        view.addSubview(explainLabel)
        explainLabel.text = "소중한 레시피 작성에 감사합니다."
        explainLabel.textColor = .black
        explainLabel.textAlignment = .center
        explainLabel.font = UIFont(name: KeyWord.CustomFont, size: 25)
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        view.addSubview(animationView)
        animationView.play()
        animationView.loopMode = .loop
        animationView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottomMargin).offset(50)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(250)
        }
        
        view.addSubview(goToRecipeButton)
        goToRecipeButton.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp_bottomMargin).offset(50)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
        
        view.addSubview(goToHomeButton)
        goToHomeButton.snp.makeConstraints { make in
            make.top.equalTo(goToRecipeButton.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
    }
    
    
//MARK: - ButtonMethod
    
    @objc private func homeButtonPressed(_ sender : UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func recipeButtonPressed(_ sender : UIButton){
        
    }
    
    
//MARK: - DataMethod
    
    
}
