//
//  ProfileViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseAuth

final class ProfileViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    final var userInformationData : UserInformationData = .init(name: "", email: "", login: "")
    
    private let nameLabel = UILabel()
    private lazy var nameTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.clearButtonMode = .always
        tf.tintColor = .black
        tf.textColor = .black
        tf.font = .boldSystemFont(ofSize: 17)
        tf.delegate = self
        
        return tf
    }()
    
    private let emailLabel = UILabel()
    private lazy var emailTextField : UITextField = {
        let tf = UITextField()
        tf.isUserInteractionEnabled = false
        tf.backgroundColor = .clear
        tf.tintColor = .black
        tf.textColor = .black
        tf.font = .boldSystemFont(ofSize: 17)
        tf.delegate = self
        
        return tf
    }()
    
    private let loginLabel = UILabel()
    private lazy var loginTextField : UITextField = {
        let tf = UITextField()
        tf.isUserInteractionEnabled = false
        tf.backgroundColor = .clear
        tf.tintColor = .black
        tf.textColor = .black
        tf.font = .boldSystemFont(ofSize: 17)
        tf.delegate = self
        
        return tf
    }()
    
    private let userImageView = UIImageView()
    
    
    private lazy var saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        viewChange()
        setUserInfomationData()
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func viewChange() {
        
        view.backgroundColor = .customWhite
        
        view.addSubview(userImageView)
        userImageView.tintColor = .customSignature
        userImageView.image = UIImage(systemName: "person.circle")
        userImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.height.equalTo(70)
        }
        
        view.addSubview(nameLabel)
        nameLabel.text = "닉네임"
        nameLabel.textColor = .customSignature
        nameLabel.font = .boldSystemFont(ofSize: 12)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp_bottomMargin).offset(30)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        view.addSubview(nameTextField)
        textFieldBorderCustom(target: nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottomMargin)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(emailLabel)
        emailLabel.text = "이메일"
        emailLabel.textColor = .customSignature
        emailLabel.font = .boldSystemFont(ofSize: 12)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp_bottomMargin).offset(30)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        view.addSubview(emailTextField)
        textFieldBorderCustom(target: emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp_bottomMargin)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(loginLabel)
        loginLabel.text = "로그인 정보"
        loginLabel.textColor = .customSignature
        loginLabel.font = .boldSystemFont(ofSize: 12)
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp_bottomMargin).offset(30)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        view.addSubview(loginTextField)
        textFieldBorderCustom(target: loginTextField)
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp_bottomMargin)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
    }
    
    private func textFieldBorderCustom(target : UITextField) {
        
        let border = UIView()
        border.backgroundColor = .customSignature
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: nameTextField.frame.width, height: 2)
        target.addSubview(border)
        //특정 border line
    }
    
    private func setUserInfomationData() {
        self.nameTextField.text = userInformationData.name
        self.emailTextField.text = userInformationData.email
        
        switch userInformationData.login {
        case "kakao":
            self.loginTextField.text = "카카오 로그인"
        case "naver":
            self.loginTextField.text = "네이버 로그인"
        case "appleLogin":
            self.loginTextField.text = "애플 로그인"
        default:
            self.loginTextField.text = "이메일 로그인"
            
        }
    } //유저로그인 정보를 textfield에 보기 쉽게 넣어주는 역할.
    
//MARK: - ButtonMethod
    @objc private func saveButtonPressed(_ sender : UIButton) {
        updateUserNickName()
    }
}

//MARK: - Extension
extension ProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//프로필 변경
extension ProfileViewController {
    private func updateUserNickName() {
        guard let user = Auth.auth().currentUser else{return}
        guard let name = nameTextField.text else{return}
        
        if name != self.userInformationData.name { //닉네임에 변경사항이 있을 때
            
            if name == "" {
                CustomAlert.show(title: "오류", subMessage: "닉네임을 작성해주세요.")
            }else{
                CustomLoadingView.shared.startLoading(alpha: 0.5)
                
                db.collection("Users").document(user.uid).updateData([DataKeyWord.myName : name]) { error in
                    if let e = error{
                        print("Error 유저 이름 업데이트 실패 : \(e.localizedDescription)")
                    }else{
                        DispatchQueue.main.async {
                            CustomLoadingView.shared.stopLoading()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                self.updateRecipeNickName(changedName: name, userUID: user.uid)
                
                
            }
        }
    }
    
    private func updateRecipeNickName(changedName : String, userUID : String) {
        
        db.collection("전체보기").getDocuments { qs, error in
            if let e = error {
                print("Error 내 레시피 정보 가져오기 : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                if let snapShotDocuments = qs?.documents {
                    
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        
                        guard let userUIDData = data[DataKeyWord.userUID] as? String else{return print("faile")}
                        
                        if userUID == userUIDData { //해당 도큐먼트의 주인이 나일 때, 닉네임 부분 변경
                            self.db.collection("전체보기").document(doc.documentID).updateData([DataKeyWord.userName : changedName])
                        }
                        
                        //댓글에서 내 닉네임 수정.
                        self.updateCommentsName(documentID: doc.documentID, changedName: changedName, userUID: userUID)
                    }
                }else{
                    print("해당 데이터 없음.")
                }
            }
        }
    }
    
    private func updateCommentsName(documentID : String, changedName : String, userUID : String) {
        //댓글데이터에서 내가 작성한 댓글 데이터들 중 이름부분 모두 변경된 이름으로 변경
        self.db.collection("전체보기").document(documentID).collection("댓글").whereField(DataKeyWord.userUID, isEqualTo: userUID).getDocuments { qs, error in
            if let e = error {
                print("Error 내 레시피 정보 가져오기 : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                
                if let snapShotDocuments = qs?.documents{
                    for doc in snapShotDocuments{
                        self.db.collection("전체보기").document(documentID).collection("댓글").document(doc.documentID).updateData([DataKeyWord.userName : changedName])
                    }
                    
                }else{
                    print("해당 도큐먼트 없음.")
                }
            }
        }
    }
}
