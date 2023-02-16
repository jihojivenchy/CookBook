//
//  WriteNickNameViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/19.
//

import UIKit
import SnapKit

final class WriteNickNameViewController: UIViewController {
//MARK: - Properties
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let progressBar = UIProgressView()
    private let titleLabel = UILabel()
    
    private let nickNameTextField = UITextField()
    
    private lazy var checkBoxButton : UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.customSignature?.cgColor
        button.setImage(UIImage(systemName: "checkmark"), for: .selected)
        button.tintColor = .customSignature
        button.addTarget(self, action: #selector(checkBoxPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    private var checkSign : Bool = false
    
    private let agreeLabel = UILabel()
    private lazy var agreeButton : UIButton = {
        let button = UIButton()
        button.setTitle("(약관 보기)", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(agreeButtonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
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
        progressBar.progress = 0.25
        progressBar.progressTintColor = .customSignature
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(7)
        }
        
        view.addSubview(titleLabel)
        titleLabel.text = "닉네임 작성과 함께 약관에 \n동의해주세요"
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .customNavy
        titleLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 25)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(90)
        }
        
        view.addSubview(nickNameTextField)
        textFieldBorderCustom()
        nickNameTextField.tintColor = .black
        nickNameTextField.returnKeyType = .done
        nickNameTextField.clearButtonMode = .always
        nickNameTextField.placeholder = "닉네임을 작성해주세요"
        nickNameTextField.font = .systemFont(ofSize: 16)
        nickNameTextField.delegate = self
        nickNameTextField.textColor = .black
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
        
        view.addSubview(checkBoxButton)
        checkBoxButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp_bottomMargin).offset(60)
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
        
        view.addSubview(agreeLabel)
        agreeLabel.text = "개인정보 이용 및 수집 동의(필수)"
        agreeLabel.textColor = .customNavy
        agreeLabel.font = .systemFont(ofSize: 15)
        agreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkBoxButton)
            make.left.equalTo(checkBoxButton.snp_rightMargin).offset(15)
            make.height.equalTo(30)
        }
        
        view.addSubview(agreeButton)
        agreeButton.snp.makeConstraints { make in
            make.centerY.equalTo(agreeLabel)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(30)
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
        border.frame = CGRect(x: 0, y: 0, width: nickNameTextField.frame.width, height: 2)
        nickNameTextField.addSubview(border)
        //특정 border line
    }
    
//MARK: - ButtonMethod

    @objc private func checkBoxPressed(_ sender : UIButton){
        sender.isSelected.toggle()
        if sender.isSelected == true{
            checkSign = true
        }else{
            checkSign = false
        }
    }
    
    @objc private func agreeButtonPressed(_ sender : UIButton){
        let centerURL = "https://iosjiho.tistory.com/51"
        let contractURL = NSURL(string: centerURL)
        
        if UIApplication.shared.canOpenURL(contractURL! as URL){
            
            UIApplication.shared.open(contractURL! as URL)
        }
    }
    
    @objc private func nextButtonPressed(_ sender : UIButton){
        guard let name = nickNameTextField.text else{return}
        
        if name == "" {
            CustomAlert.show(title: "오류", subMessage: "닉네임을 입력해주세요.")
            
        }else{
            if checkSign == true {
                let vc = WriteEmailViewController()
                vc.nickName = name
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                CustomAlert.show(title: "오류", subMessage: "약관에 동의해주세요.")
            }
        }
        
        
    }
}

//MARK: - Extension
extension WriteNickNameViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
}
