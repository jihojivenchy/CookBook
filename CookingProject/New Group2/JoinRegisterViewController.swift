//
//  JoinRegisterViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/20.
//


import UIKit
import SnapKit
import Firebase
import FirebaseFirestore

class JoinRegisterViewController : UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    private let scrollView = UIScrollView()
    
    private let nickNameLabel = UILabel()
    private lazy var nickNameTextfield : UITextField = {
        let nt = UITextField()
        nt.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) //여백주기
        nt.leftViewMode = .always
        nt.backgroundColor = .white
        nt.layer.borderWidth = 1
        nt.clearButtonMode = .always
        nt.layer.cornerRadius = 10
        nt.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray ?? UIColor.lightGray])
        nt.layer.borderColor = UIColor.customGray?.cgColor
        nt.textColor = .black
        nt.delegate = self
        
        return nt
    }()
    
    private let stopLabel = UILabel()
    private let stopLabe2 = UILabel()
    private let stopLabe3 = UILabel()
    
    
    private let IDLabel = UILabel()
    private lazy var idTextField : UITextField = {
        let it = UITextField()
        it.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) //여백주기
        it.leftViewMode = .always
        it.backgroundColor = .white
        it.layer.borderWidth = 1
        it.clearButtonMode = .always
        it.layer.cornerRadius = 10
        it.attributedPlaceholder = NSAttributedString(string: "아이디를 입력하세요(이메일 형식)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray ?? UIColor.lightGray])
        it.layer.borderColor = UIColor.customGray?.cgColor
        it.textColor = .black
        
        return it
    }()
    
    private let passwordLabel = UILabel()
    private lazy var passwordTextField : UITextField = {
        let pt = UITextField()
        pt.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        pt.leftViewMode = .always
        pt.backgroundColor = .white
        pt.isSecureTextEntry = true
        pt.layer.borderWidth = 1
        pt.clearButtonMode = .always
        pt.layer.cornerRadius = 10
        pt.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray ?? UIColor.lightGray])
        pt.layer.borderColor = UIColor.customGray?.cgColor
        pt.textColor = .black
        
        return pt
    }()
    
    private lazy var checkBoxButton : UIButton = {
        let cb = UIButton()
        cb.layer.borderWidth = 1
        cb.layer.borderColor = UIColor.red.cgColor
        cb.setImage(UIImage(systemName: "checkmark"), for: .selected)
        cb.tintColor = .red
        cb.addTarget(self, action: #selector(checkBoxPressed(_:)), for: .touchUpInside)
        
        return cb
    }()
    private var checkSign : Bool = false
    
    private let agreeLabel = UILabel()
    private lazy var infomationButton : UIButton = {
        let ib = UIButton()
        ib.setTitle("(약관 보기)", for: .normal)
        ib.setTitleColor(.customPink, for: .normal)
        ib.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        ib.addTarget(self, action: #selector(informationButtonPressed(_:)), for: .touchUpInside)
        
        return ib
    }()
    
    
    
    private lazy var registerButton : UIButton = {
        let rb = UIButton()
        rb.setTitle("회원가입", for: .normal)
        rb.backgroundColor = .customPink
        rb.setTitleColor(.white, for: .normal)
        rb.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
        return rb
    }()
    
    private lazy var homeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(homeButtonPressed(_:)))
        
        return button
    }()
    
    private let adView = UIView()
    
    private lazy var indicatorView : UIActivityIndicatorView = {
       let ia = UIActivityIndicatorView()
        ia.hidesWhenStopped = true
        ia.style = .large
        
        return ia
    }()
    
//MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        
        viewChange()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))//개체들이 모두 스크롤뷰 위에 존재하기 때문에 스크롤뷰 특성 상 touchBegan함수가 실행되지 않는다. 따라서 스크롤뷰에 대한 핸들러 캐치를 등록해주어야 한다.
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = self.homeButton
        
        navigationItem.title = "회원가입"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func viewChange() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.indicatorStyle = .white
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets)
            make.right.left.equalTo(view)
            make.bottom.equalTo(view.safeAreaInsets)
        }
        
        scrollView.addSubview(nickNameLabel)
        nickNameLabel.text = "닉네임"
        nickNameLabel.textColor = .black
        nickNameLabel.font = .systemFont(ofSize: 20)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView).inset(50)
            make.left.right.equalTo(view).inset(30)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(nickNameTextfield)
        nickNameTextfield.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp_bottomMargin).offset(10)
            make.left.right.equalTo(view).inset(30)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(stopLabel)
        stopLabel.text = "9글자 이하로 작성해주세요"
        stopLabel.textColor = .customPink
        stopLabel.font = .systemFont(ofSize: 11)
        stopLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextfield.snp_bottomMargin).offset(10)
            make.left.right.equalTo(view).inset(33)
            make.height.equalTo(15)
        }
        
        scrollView.addSubview(IDLabel)
        IDLabel.text = "아이디"
        IDLabel.textColor = .black
        IDLabel.font = .systemFont(ofSize: 20)
        IDLabel.snp.makeConstraints { make in
            make.top.equalTo(stopLabel.snp_bottomMargin).offset(30)
            make.left.right.equalTo(view).inset(30)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(idTextField)
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(IDLabel.snp_bottomMargin).offset(10)
            make.left.right.equalTo(view).inset(30)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(stopLabe2)
        stopLabe2.text = "이메일 형식(@필수)"
        stopLabe2.textColor = .customPink
        stopLabe2.font = .systemFont(ofSize: 11)
        stopLabe2.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp_bottomMargin).offset(10)
            make.left.right.equalTo(view).inset(33)
            make.height.equalTo(15)
        }
        
        scrollView.addSubview(passwordLabel)
        passwordLabel.text = "비밀번호"
        passwordLabel.textColor = .black
        passwordLabel.font = .systemFont(ofSize: 20)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(stopLabe2.snp_bottomMargin).offset(30)
            make.left.right.equalTo(view).inset(30)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp_bottomMargin).offset(10)
            make.left.right.equalTo(view).inset(30)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(stopLabe3)
        stopLabe3.text = "7글자 이상 작성"
        stopLabe3.textColor = .customPink
        stopLabe3.font = .systemFont(ofSize: 11)
        stopLabe3.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp_bottomMargin).offset(10)
            make.left.right.equalTo(view).inset(33)
            make.height.equalTo(15)
        }
        
        scrollView.addSubview(checkBoxButton)
        checkBoxButton.snp.makeConstraints { make in
            make.top.equalTo(stopLabe3.snp_bottomMargin).offset(70)
            make.left.equalTo(scrollView).inset(30)
            make.height.width.equalTo(25)
        }
        
        scrollView.addSubview(agreeLabel)
        agreeLabel.text = "개인정보 이용 및 수집 동의(필수)"
        agreeLabel.textColor = .black
        agreeLabel.font = .systemFont(ofSize: 14)
        agreeLabel.snp.makeConstraints { make in
            make.top.equalTo(stopLabe3.snp_bottomMargin).offset(70)
            make.left.equalTo(checkBoxButton.snp_rightMargin).offset(15)
            make.width.equalTo(190)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(infomationButton)
        infomationButton.snp.makeConstraints { make in
            make.top.equalTo(stopLabe3.snp_bottomMargin).offset(70)
            make.right.equalTo(view).inset(30)
            make.width.equalTo(60)
            make.height.equalTo(30)
            
        }
        
        scrollView.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(agreeLabel.snp_bottomMargin).offset(30)
            make.left.right.equalTo(view).inset(30)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(adView)
        adView.backgroundColor = .white
        adView.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp_bottomMargin).offset(30)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(200)
            make.bottom.equalTo(scrollView).inset(20)
        }
        
        scrollView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(100)
        }
        
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }//스크롤뷰 터치 시에 endEditing 발생
    
    private func setAlert(message : String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default) { action in
            if message == "회원가입을 축하합니다" {
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//MARK: - ButtonMethod
    
    @objc func registerButtonPressed(_ sender : UIButton){
        
        if checkSign == true{
            
            if passwordTextField.text?.count ?? 0 > 6 {
                
                if let email = idTextField.text, let password = passwordTextField.text, let nickName = nickNameTextfield.text{
                    self.indicatorView.startAnimating()
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let e = error{
                            print(e.localizedDescription)
                            self.indicatorView.stopAnimating()
                            self.setAlert(message: "회원가입 실패")
                        }else{
                            
                            guard let user = authResult?.user else {return}
                            
                            self.db.collection("Users").document(user.uid).setData(["NickName" : nickName])
                            
                            self.indicatorView.stopAnimating()
                            self.setAlert(message: "회원가입을 축하합니다")
                        }
                    }
                }
            }else{
               setAlert(message: "비밀번호 형식을 맞춰주세요.")
            }
        }else{
            setAlert(message: "약관에 동의해주셔야합니다.")
        }
    }
    
    @objc private func checkBoxPressed(_ sender : UIButton){
        sender.isSelected.toggle()
        if sender.isSelected == true{
            checkSign = true
        }else{
            checkSign = false
        }
    }
    
    @objc private func informationButtonPressed(_ sender : UIButton){
        let centerURL = "https://iosjiho.tistory.com/51"
        let contractURL = NSURL(string: centerURL)
        
        if UIApplication.shared.canOpenURL(contractURL! as URL){
            
            UIApplication.shared.open(contractURL! as URL)
        }
    }
    
    @objc private func homeButtonPressed(_ sender : UIBarButtonItem){
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    
}



//MARK: - Extension
extension JoinRegisterViewController : UITextFieldDelegate {
    
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
        
        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
        if text.count > 8 {
            return false
        }
        
        return true
    }
}

