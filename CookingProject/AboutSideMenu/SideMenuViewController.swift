//
//  SideMenuViewControllerViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/22.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import SCLAlertView
import NaverThirdPartyLogin
import KakaoSDKUser

final class SideMenuViewController: UIViewController {
    //MARK: - Properties
    private let db = Firestore.firestore()
    private var userInformationData : UserInformationData = .init(name: "", email: "", login: "")
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private lazy var dismissButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(dismissButtonPressed(_:)))
        
        return sb
    }()
    
    private let menuTableView = UITableView(frame: .zero, style: .grouped)
    
    private var menuImageArray = ["list.bullet.rectangle.portrait", "person.badge.minus", "bell", "message", "rectangle.portrait.and.arrow.right"]
    private var menuTitleArray = ["작성한 글", "차단유저 관리", "설정", "피드백", "로그아웃"]
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = .customSignature
        rf.addTarget(self, action: #selector(reloadAction(_:)), for: .valueChanged)
        
        return rf
    }()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLoginState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        naviBarAppearance()
        
        getUsereData()
        
        menuTableView.refreshControl = refresh
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        menuTableView.rowHeight = 70
    }
    
    //MARK: - ViewMethod
    
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = .customSignature
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = dismissButton
    }
    
    private func addSubViews() {
        view.backgroundColor = .customSignature
        
        view.addSubview(menuTableView)
        menuTableView.backgroundColor = .white
        menuTableView.showsVerticalScrollIndicator = false
        menuTableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func checkLoginState() {
        if Auth.auth().currentUser != nil { //유저가 로그인 상태가 아니라면 로그인 뷰로 고고
            self.menuImageArray[4] = "rectangle.portrait.and.arrow.right"
            self.menuTitleArray[4] = "로그아웃"
            
            self.menuTableView.reloadData()
        }else{
            self.menuImageArray[4] = "iphone.and.arrow.forward"
            self.menuTitleArray[4] = "로그인"
            
            self.menuTableView.reloadData()
        }
    } //login check
    
    
    @objc private func reloadAction(_ sender : UIRefreshControl) {
        menuTableView.reloadData()
        refresh.endRefreshing()
    }
    
    
    //MARK: - ButtonMethod
    @objc private func dismissButtonPressed(_ sender : UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    //MARK: - DataMethod
    private func getUsereData(){
        
        if let user = Auth.auth().currentUser {
            
            db.collection("Users").document("\(user.uid)").getDocument { qs, error in
                if let e = error {
                    print("Error 유저 데이터 가져오기 실패 \(e)")
                }else{
                    guard let userData = qs?.data() else {return} //해당 도큐먼트 안에 데이터가 있는지 확인
                    
                    guard let userEmailData = user.email else{return} //유저 이메일
                    guard let userNameData = userData["NickName"] as? String else{return} //유저 닉네임
                    guard let userLoginData = userData["login"] as? String else{return}
                    
                    self.userInformationData = UserInformationData(name: userNameData, email: userEmailData, login: userLoginData)
                    
                    DispatchQueue.main.async {
                        self.menuTableView.reloadData()
                    }
                }
            }
        }else{
            self.userInformationData = UserInformationData(name: "로그인", email: "로그인이 필요합니다.", login: "")
        }
    }
    
}

//MARK: - Extension
extension SideMenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.menuTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath) as! SideMenuTableViewCell
        
        cell.menuImageView.image = UIImage(systemName: self.menuImageArray[indexPath.row])
        cell.menuLabel.text = self.menuTitleArray[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeaderView = SideMenuHeaderView()
        
        customHeaderView.nameLabel.text = self.userInformationData.name
        customHeaderView.emailLabel.text = self.userInformationData.email
        
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}

extension SideMenuViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(MyBookViewController(), animated: true)
        }else if indexPath.row == 1 {
            
        }else if indexPath.row == 2 {
            
        }else if indexPath.row == 3 {
            
        }else {
            if menuTitleArray[4] == "로그인" {
                loginOrLogout(title: "로그인", subMessage: "로그인 하시겠습니까?")
            
            }else{
                loginOrLogout(title: "로그아웃", subMessage: "로그아웃 하시겠습니까?")
            }
        }
        
        
    }
}

//MARK: - LogOutMethod
extension SideMenuViewController {
    
    private func loginOrLogout(title : String, subMessage : String) {
        let appearence = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: "EF_watermelonSalad", size: 17) ?? .boldSystemFont(ofSize: 17), kTextFont: UIFont(name: "EF_watermelonSalad", size: 13) ?? .boldSystemFont(ofSize: 13), showCloseButton: false)
        let alert = SCLAlertView(appearance: appearence)
        
        alert.addButton("확인", backgroundColor: .customSignature, textColor: .white) {
            if title == "로그인" {
                self.goToLogin()
            }else{
                self.goToLogout()
            }
        }
        
        alert.addButton("취소", backgroundColor: .customSignature, textColor: .white) {
            print("취소")
        }
        
        alert.showSuccess(title,
                          subTitle: subMessage,
                          colorStyle: 0xFFB6B9,
                          colorTextButton: 0xFFFFFF)
    }
    
    private func goToLogin() {
        self.navigationController?.pushViewController(SocialLoginViewController(), animated: true)
    }
    
    private func goToLogout() {
        //유저가 로그인을 어떤 방식을 사용했는지
        switch userInformationData.login {
            
        case "kakao":
            UserApi.shared.logout { error in
                if let e = error {
                    print("Error 카카오 로그아웃 실패 : \(e)")
                }else{
                    print("카카오 로그아웃 성공")
                }
            }
            
        case "naver":
            NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken() //네이버 로그인 토큰 삭제
            
        default:
            print("외부 로그인 사용")
        }
        
        firebaseLogOut()
    }
    
    private func firebaseLogOut() {
        do {
            try Auth.auth().signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            CustomAlert.show(title: "로그아웃 실패", subMessage: "다시 실행해주세요.")
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(SocialLoginViewController(), animated: true)
        }
    }
    
}