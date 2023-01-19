//
//  ProfileViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit
import FirebaseFirestore
import Firebase

class ProfileViewController: UIViewController {
    
//MARK: - Properties
    private let db = Firestore.firestore()
    
    private let nickNameLabel = UILabel()
    
    private lazy var nickTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요(9글자 이하)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray ?? UIColor.lightGray]) //placeholder의 컬러를 바꿔주는 코드
        tf.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        tf.leftViewMode = .always
        tf.clearButtonMode = .always
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        tf.layer.borderColor = UIColor.customPink?.cgColor
        tf.textColor = .black
        tf.delegate = self
        
        return tf
    }()
    
    private let nickname : String = "닉네임"
    
    private lazy var modifyButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "수정완료", style: .done, target: self, action: #selector(modifyAlert(_:)))
        
        return sb
    }()
    
//MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        viewChange()
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "프로필 변경"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = modifyButton
    }
    
    private func viewChange() {
        
        view.backgroundColor = .white
        
        view.addSubview(nickNameLabel)
        nickNameLabel.text = "닉네임"
        nickNameLabel.textColor = .black
        nickNameLabel.font = .systemFont(ofSize: 18)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view).inset(200)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        view.addSubview(nickTextField)
        nickTextField.snp.makeConstraints { make in
            make.top.equalTo(view).inset(200)
            make.left.equalTo(nickNameLabel.snp_rightMargin).offset(10)
            make.right.equalTo(view).inset(10)
            make.height.equalTo(40)
        }
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
        
    }
    
    private func errorAlert() {
        let alert = UIAlertController(title: "닉네임을 입력해주세요", message: nil, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        present(alert, animated: false, completion: nil)
    }
    
//MARK: - ButtonMethod
    @objc private func modifyAlert(_ sender : UIBarButtonItem) {
        let alert = UIAlertController(title: "저장하시겠습니까?", message: "저장이 완료되면 앱을 재부팅해주세요", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "저장", style: .default) { action in
            guard let user = Auth.auth().currentUser else {return}
            
            
            if let nick = self.nickTextField.text {
                self.db.collection("Users").document(user.uid).updateData(["NickName" : "\(nick)"])
                self.navigationController?.popViewController(animated: true)
            }else{
                self.errorAlert()
                
            }
        }
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        alert.addAction(cancel)
        
        present(alert, animated: false, completion: nil)
    }
}

//MARK: - Extension
extension ProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }//백스페이스는 감지할 수 있도록 하는 코드
        
        guard let text = textField.text else {return false}
        
        // 제한 글자수 이상을 입력한 이후에는 작동이멈춤.
        if text.count > 8 {
            return false
        }
        
        return true
    }
}
