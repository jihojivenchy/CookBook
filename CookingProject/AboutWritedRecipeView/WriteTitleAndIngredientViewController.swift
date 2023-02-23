//
//  WriteTitleViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/27.
//

import UIKit
import SnapKit

final class WriteTitleAndIngredientViewController: UIViewController {
    //MARK: - Properties
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let stackView = UIStackView()
    private let progressBar = UIProgressView()
    private let introduceLabel = UILabel()
    
    private let titleLabel = UILabel()
    private lazy var titleTextField : UITextField = {
        let tf = UITextField()
        tf.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        tf.leftViewMode = .always
        tf.backgroundColor = .white
        tf.clearButtonMode = .always
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 5
        tf.tintColor = .black
        tf.textColor = .black
        tf.font = .boldSystemFont(ofSize: 17)
        tf.delegate = self
        
        return tf
    }()
    
    private let ingredientsLabel = UILabel()
    private lazy var ingredientsTextView : UITextView = {
        let tv = UITextView()
        tv.returnKeyType = .next
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 5
        tv.font = .boldSystemFont(ofSize: 17)
        tv.textColor = .black
        tv.tintColor = .black
        tv.backgroundColor = .white
        tv.delegate = self
        return tv
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
    
    final var sendedArray : [String] = ["", "", "", ""]
    final var selectedTime = String()
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        
        addSubViews()
        setStackView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    //MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func addSubViews() {
        view.backgroundColor = .customWhite
        
        view.addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(20)
        }
        
        view.addSubview(progressBar)
        progressBar.backgroundColor = .lightGray
        progressBar.progress = 0.5
        progressBar.progressTintColor = .customSignature
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp_bottomMargin).offset(5)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(7)
        }
        
        view.addSubview(introduceLabel)
        introduceLabel.text = "제목과 재료를 작성해주세요."
        introduceLabel.textColor = .black
        introduceLabel.textAlignment = .center
        introduceLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 25)
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        view.addSubview(titleLabel)
        titleLabel.text = "제목"
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 15)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(27)
            make.height.equalTo(30)
        }
        
        view.addSubview(titleTextField)
        titleTextField.textFieldBorderCustom(target: titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
        
        view.addSubview(ingredientsLabel)
        ingredientsLabel.text = "재료"
        ingredientsLabel.textColor = .black
        ingredientsLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 15)
        ingredientsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(27)
            make.height.equalTo(30)
        }
        
        view.addSubview(ingredientsTextView)
        ingredientsTextView.snp.makeConstraints { make in
            make.top.equalTo(ingredientsLabel.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(150)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(ingredientsTextView.snp_bottomMargin).offset(70)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(55)
        }
    }
    
    private func setStackView() {
        
        for i in sendedArray {
            
            let label = UILabel()
            label.text = i
            label.textAlignment = .center
            label.textColor = .black
            label.backgroundColor = .clear
            label.font = UIFont(name: FontKeyWord.CustomFont, size: 11)
            label.clipsToBounds = true
            label.layer.cornerRadius = 7
            
            self.stackView.addArrangedSubview(label)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
    }
    
    //MARK: - ButtonMethod
    
    @objc private func nextButtonPressed(_ sender : UIButton){
        guard let titleText = self.titleTextField.text else{return}
        guard let ingreText = self.ingredientsTextView.text else{return}
        
        if titleText == "" {
            CustomAlert.show(title: "오류", subMessage: "제목을 작성해주세요.")
        }else{
            
            if ingreText == "" {
                CustomAlert.show(title: "오류", subMessage: "재료를 작성해주세요.")
            }else{
                self.sendedArray[2] = titleText
                
                let vc = WriteRecipeProcessViewController()
                vc.sendedArray = self.sendedArray
                vc.selectedTime = self.selectedTime
                vc.ingredients = ingreText
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
//MARK: - Keyboard Notification Method
    private func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ noti: NSNotification){
        UIView.animate(withDuration: 0.3, animations: {
            self.ingredientsLabel.transform = CGAffineTransform(translationX: 0, y: -100)
            self.ingredientsTextView.transform = CGAffineTransform(translationX: 0, y: -100)
            
            self.titleLabel.alpha = 0
            self.titleTextField.alpha = 0
        })
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc private func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        UIView.animate(withDuration: 0.3, animations: {
            self.ingredientsLabel.transform = .identity
            self.ingredientsTextView.transform = .identity
            
            self.titleLabel.alpha = 1
            self.titleTextField.alpha = 1
        })
    }

    // 노티피케이션을 제거하는 메서드
    private func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
}
//MARK: - Extension
extension WriteTitleAndIngredientViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.removeKeyboardNotifications()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
}

extension WriteTitleAndIngredientViewController : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.addKeyboardNotifications()
        
        return true
    }
}

