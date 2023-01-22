//
//  SocialLoginViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/16.
//

import UIKit
import SnapKit
import KakaoSDKUser
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore
import NaverThirdPartyLogin
import Alamofire
import NVActivityIndicatorView

final class SocialLoginViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    fileprivate var currentNonce: String?
    private let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private let titleLabel = UILabel()
    
    private let backGroundView = UIView()
    private let idTextField = UITextField()
    private let pwTextField = UITextField()
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private lazy var findPWButton : UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setUnderLine()    //버튼에 언더라인 추가 (extension)
        button.addTarget(self, action: #selector(findButtonPressed(_:)), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private let registerLabel = UILabel()
    private lazy var registerButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(registerButtonPressed(_:)), for: .touchUpInside)
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
        loginInstance?.delegate = self
        
    }
    
    private func naviBarAppearance() {
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
    }
    
   
    private func addSubViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.text = "요리도감"
        titleLabel.textColor = .customSignature
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "EF_watermelonSalad", size: 35) //ChosunCentennial
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
        idTextField.delegate = self
        idTextField.returnKeyType = .done
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
        pwTextField.delegate = self
        pwTextField.returnKeyType = .done
        pwTextField.placeholder = "비밀번호를 입력해주세요."
        pwTextField.font = .boldSystemFont(ofSize: 16)
        pwTextField.backgroundColor = .clear
        pwTextField.textColor = .black
        pwTextField.tintColor = .black
        pwTextField.clearButtonMode = .whileEditing
        pwTextField.isSecureTextEntry = true
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
    @objc func findButtonPressed(_ sender : UIButton) {
        self.navigationController?.pushViewController(FindPasswordViewController(), animated: true)
    }
    
    
    @objc func registerButtonPressed(_ sender : UIButton) {
        self.navigationController?.pushViewController(WriteNickNameViewController(), animated: true)
    }
    
    @objc func loginButtonPressed(_ sender : UIButton) {
        guard let email = idTextField.text else{return}
        guard let password = pwTextField.text else{return}
        
        if email == "", password == "" {
            CustomAlert.show(title: "오류", subMessage: "양식에 맞게 작성해주세요.")
        }else{
            CustomLoadingView.shared.startLoading()
            firebaseLogin(email: email, password: password)
        }
    }
    
    @objc func kakaoLoginPressed(_ sender : UIButton) {
        kakaoInstallCheck()
    }
    
    @objc func naverLoginPressed(_ sender : UIButton) {
        CustomLoadingView.shared.startLoading()
        loginInstance?.requestThirdPartyLogin()
    }
    
    @objc func appleLoginPressed(_ sender : UIButton) {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        DispatchQueue.main.async {
            CustomLoadingView.shared.startLoading()
        }
    }
    
    //로그인 요청과 함께 nonce의 SHA256 해시를 보내면 Apple이 응답에서 변경하지 않고 전달합니다. Firebase는 원래 nonce를 해싱하고 이를 Apple에서 전달한 값과 비교하여 응답의 유효성을 검사합니다.
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}

//MARK: - Extension
extension SocialLoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
    }
}

//MARK: - KaKao Social Login
extension SocialLoginViewController {
    private func kakaoInstallCheck() {
        CustomLoadingView.shared.startLoading()
        
        if (UserApi.isKakaoTalkLoginAvailable()) { //카톡 설치 확인
            
            //카톡 설치되어있으면 -> 카톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let e = error {
                    print(e)
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                        CustomAlert.show(title: "오류", subMessage: "카카오 로그인 실패")
                    }
                } else {
                    print("카카오 톡으로 로그인 성공")
                    self.kakaoLoginUserInfo()
                    
                }
            }
        }else{
            // 카톡 없으면 -> 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let e = error {
                    print(e)
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                        CustomAlert.show(title: "오류", subMessage: "카카오 로그인 실패")
                    }
                    
                } else {
                    print("카카오 계정으로 로그인 성공")
                    self.kakaoLoginUserInfo()

                }
            }
        }
    }
    
    private func kakaoLoginUserInfo() {
        // 카카오톡 로그인 성공 유저의 이메일과 닉네임 가져오기.
        UserApi.shared.me() { user, error in
            if let error = error {
                print("Error 카카오톡 사용자 정보가져오기 에러 \(error.localizedDescription)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    CustomAlert.show(title: "오류", subMessage: "유저 정보를 가져오는데 실패.")
                }
                
            } else {
                print("유저 정보 가져오기 성공")
                guard let email = user?.kakaoAccount?.email else{return}
                guard let nickName = user?.kakaoAccount?.profile?.nickname else{return}
                guard let password = user?.id else{return}
                
                self.firebaseRegisterOrLogin(email: email, password: "\(password)", nickName: nickName, login: "kakao")
            }
        }
    }
}

//MARK: - Naver Social Login
extension SocialLoginViewController : NaverThirdPartyLoginConnectionDelegate{
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() { //로그인에 성공했을 때(액세스 토큰 요청)
        print("로그인성공")
        naverLoginUserInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {//refresh 토큰 요청 완료일 때
        print("Receive Refresh token")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() { //로그아웃 완료
        print("LogOut")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) { //에러 다루기
        print("Error 네이버 로그인 실패 : \(error.localizedDescription)")
        
        DispatchQueue.main.async {
            CustomLoadingView.shared.stopLoading()
        }
        
    }
    
    private func naverLoginUserInfo() {
        
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            return
        }
        
        guard let tokenType = loginInstance?.tokenType else { return}
        guard let accessToken = loginInstance?.accessToken else {return}
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseData { response in
            
            switch response.result {
                
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(NaverResponse.self, from: data)
                    
                    let emailData = json.response.email
                    let nickNameData = json.response.name
                    
                    self.firebaseRegisterOrLogin(email: emailData, password: "\(nickNameData)000", nickName: nickNameData, login: "naver")
                    
                } catch {
                    print("캐치 에러 : \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                    }
                }
                
            case .failure(let error):
                print("데이터 받기 에러 : \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }
            
        }
    }
    
    
    
}

//MARK: - Apple Social Login
extension SocialLoginViewController : ASAuthorizationControllerDelegate{
    // Apple ID 연동 성공 시
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //몇 가지 표준 키 검사를 실행
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            //1. 현재 nonce가 설정되어 있는지
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            //2. ID 토큰 검색
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            //3. ID 토큰을 문자열로 변환
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
           
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let e = error {
                    print(e.localizedDescription)
                    
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                    }
                    return
                }else{
                    
                    guard let user = authResult?.user else{return}
                    let email = user.email ?? "abcde@"
                    let name = "마음이 따듯한 요리사"
                    
                    self.db.collection("Users").document(user.uid).setData(["NickName" : name,
                                                                            "email" : email,
                                                                            "login" : "appleLogin"])
                    
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
        DispatchQueue.main.async {
            CustomLoadingView.shared.stopLoading()
        }
    }
    
    //모든 로그인 요청에 대해 임의의 문자열("nonce")을 생성하여 앱의 인증 요청에 대한 응답으로 받은 ID 토큰이 특별히 부여되었는지 확인하는 데 사용할 수 있습니다. 이 단계는 재생 공격을 방지하는 데 중요합니다
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    
}

extension SocialLoginViewController : ASAuthorizationControllerPresentationContextProviding {
    //애플 로그인 화면 표시
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

//MARK: - Firebase Login
extension SocialLoginViewController {
    private func firebaseLogin(email : String, password : String){
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error{
                print(e)
                DispatchQueue.main.async {
                    CustomAlert.show(title: "로그인 실패", subMessage: "이미 가입한 회원님 아니신가요?")
                    CustomLoadingView.shared.stopLoading()
                }
                
            }else{
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func firebaseRegisterOrLogin(email : String, password : String, nickName : String, login : String) {
        // 파이어베이스 유저 생성 (이메일로 회원가입)
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            
            if let error = error {
                print("Error 파이어베이스 회원가입 실패 \(error.localizedDescription)")
                
                self.firebaseLogin(email: email, password: password) //이미 회원이면 로그인해주기.
                
            } else {
                print("회원가입 성공")
                guard let userUID = result?.user.uid else{return}
                //유저 데이터에 로그인했던 방법과 닉네임을 저장
                self.db.collection("Users").document(userUID).setData(["NickName" : nickName,
                                                                       "email" : email,
                                                                       "login" : login])
                
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
