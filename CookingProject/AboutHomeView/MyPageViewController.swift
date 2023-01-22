//
//  MyPageController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/10.
//


import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import NaverThirdPartyLogin
import KakaoSDKUser

final class MyPageViewController : UIViewController {
//MARK: - Properties
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private var nickNameDefaults : String = ""
    private var registerID : String = ""
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let firstSectionImageArray = ["person", "list.bullet.rectangle.portrait.fill"]
    private let secondSectionImageArray = ["note.text", "person.fill.xmark.rtl", "gearshape.fill", "rectangle.portrait.and.arrow.right"]
    private let thirdSectionImageArray = ["delete.right.fill"]
    
    private let firstSectionLabelArray = ["프로필 변경", "회원도감"]
    private let secondSectionLabelArray = ["공지사항", "차단한 유저관리", "설정", "로그아웃"]
    private let thirdSectionLableArray = ["회원탈퇴"]
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(reloadAction), for: .valueChanged)
        
        return rf
    }()
    
    private lazy var indicatorView : UIActivityIndicatorView = {
       let ia = UIActivityIndicatorView()
        ia.hidesWhenStopped = true
        
        return ia
    }()
    
    
//MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserNickNameData()
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        naviBarAppearance()
        navigationTitleCustom()
        viewChange()
        
        tableView.refreshControl = refresh
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.cellID)
        

    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func viewChange() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets)
            make.left.right.equalTo(view).inset(0)
            make.height.equalToSuperview()
        }
        
        tableView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(70)
        }
    }
    
    private func navigationTitleCustom() {
        let titleName = UILabel()
        titleName.text = "My Page"
        titleName.font = UIFont(name: "EF_Diary", size: 20)
        titleName.textAlignment = .center
        titleName.textColor = .black
        titleName.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [titleName])
        stackView.axis = .horizontal
        stackView.frame.size.width = titleName.frame.width
        stackView.frame.size.height = titleName.frame.height
        
        navigationItem.titleView = stackView
        
    }
    
    @objc private func reloadAction() {
        
        tableView.reloadData()
        refresh.endRefreshing()
    }
//MARK: - CellMethod
    
    private func userLogout() {
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("Users").document(user.uid).getDocument { qs, error in
            if let e = error {
                print("Error 유저 정보 가져오기 실패 : \(e)")
            }else{
                
                if let data = qs?.data() {
                    
                    guard let loginStateData = data["login"] as? String else{return}
                    
                    switch loginStateData {
                        
                    case "kakao":
                        UserApi.shared.logout { error in
                            if let e = error {
                                print("Error 카카오 로그아웃 실패 : \(e)")
                            }else{
                                print("카카오 로그아웃 성공")
                            }
                        }
                    
                    case "naver":
                        self.loginInstance?.requestDeleteToken() //네이버 로그인 토큰 삭제
                    
                    default:
                        print("외부 로그인 사용")
                    }
                    
                    self.firebaseLogOut()
                }
            }
        }
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
    
    
    private func logoutPressed() {
        let alert = UIAlertController(title: "로그아웃", message: nil, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.userLogout()
        }
        yesAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    } //로그아웃
    
    private func userWithdrawalPressed() {
        let alert = UIAlertController(title: "회원탈퇴", message: "탈퇴가 완료되면 로그인 화면으로 전환됩니다.", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if let user = Auth.auth().currentUser {
                user.delete { error in
                    
                    if let error = error {
                        print("Fail error : \(error)")
                        self.failUserWithdrawalAlert()
                        
                    }else{
                        self.deleteUserNickNameAndBookData(uid: user.uid)
                    }
                }
            }
        }
        yesAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    } //회원탈퇴
    
    private func failUserWithdrawalAlert(){
        let alert = UIAlertController(title: "인증 만료", message: "로그아웃 후 다시 로그인해주세요!", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }

//MARK: - DataMethod
    
    private func getUserNickNameData(){
        self.indicatorView.startAnimating()
        
        if let user = Auth.auth().currentUser {
            db.collection("Users").document("\(user.uid)").getDocument { snapshot, error in
                if let e = error {
                    print("Error getdocument data \(e)")
                }else{
                    guard let userData = snapshot?.data() else {return} //해당 도큐먼트 안에 데이터가 있는지 확인
                    
                    if let saveData = userData["NickName"] as? String{ //"NickName" 필드에 데이터가 있는지 확인
                        self.nickNameDefaults = saveData
                        self.registerID = user.email ?? "error"
                        DispatchQueue.main.async {
                            self.indicatorView.stopAnimating()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
        }else{
            self.indicatorView.stopAnimating()
            nickNameDefaults = "로그인이 필요해요"
            registerID = "ID"
        }
    }
    
    private func deleteUserNickNameAndBookData(uid : String) {
        // Account deleted.
        self.db.collection("Users").document(uid).delete()//해당 유저 닉네임 정보 삭제
        
        self.db.collection(uid).document().delete() //알림 정보 삭제
        
        self.db.collection("\(uid).self").document().delete() //차단유저 정보 삭제
        
        self.db.collection("전체보기").whereField("user", isEqualTo: uid).getDocuments { snapshot, error in
            if let e = error{
                print("Error get query document : \(e)")
            }else{
                if let snapshotDocument = snapshot?.documents{
                    
                    for doc in snapshotDocument{
                        let data = doc.data()
                        
                        guard let imageFileName = data["imageFile"] as? [String] else{return}
                        self.deleteUserImageFile(title: imageFileName)
                        
                        doc.reference.delete()
                        self.db.collection("전체보기").document(doc.documentID).collection("댓글").document().delete() //하위 컬렉션 삭제
                        
                    }
                }
            }
        }
        self.performSegue(withIdentifier: "MyToLogin", sender: self)
    }
    
    private func deleteUserImageFile(title : [String]) {
        
        for imageTitle in title {
            
            let desertRef = storage.reference().child(imageTitle)
            
            desertRef.delete { error in
                if let e = error{
                    print("Error delete file : \(e)")
                }
            }
        }
    }
}

//MARK: - Extension
extension MyPageViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }else if section == 1 {
            return firstSectionLabelArray.count
        }else if section == 2 {
            return secondSectionLabelArray.count
        }else if section == 3 {
            return thirdSectionLableArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.cellID, for: indexPath) as! MyPageCell
        
        cell.tintColor = .black
        
        if indexPath.section == 1 {
            cell.labelImage.image = UIImage(systemName: firstSectionImageArray[indexPath.row])
            cell.cellLabel.text = firstSectionLabelArray[indexPath.row]
        }else if indexPath.section == 2 {
            cell.labelImage.image = UIImage(systemName: secondSectionImageArray[indexPath.row])
            cell.cellLabel.text = secondSectionLabelArray[indexPath.row]
        }else if indexPath.section == 3 {
            cell.labelImage.image = UIImage(systemName: thirdSectionImageArray[indexPath.row])
            cell.cellLabel.text = thirdSectionLableArray[indexPath.row]
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.customPink
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
}

extension MyPageViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerVIew = SideMenuHeaderView()
    
//        if section == 0 {
//            headerVIew.nameLabel.text = nickNameDefaults
//            headerVIew.idLabel.text = registerID
//            return headerVIew
//        }
//        
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //섹션 헤더타이틀
        
        if section == 1 {
            return "내 정보"
        }else if section == 2 {
            return "공지 및 기능"
        }else if section == 3 {
            return "기타"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
            headerView.textLabel?.textColor = .black
        }
    }//headertitle에 컬러넣기
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 70
        }else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1, indexPath.row == 0{ //프로필 변경
            performSegue(withIdentifier: "goToProfile", sender: self)
            
        }else if indexPath.section == 1, indexPath.row == 1{ //작성한 글
            performSegue(withIdentifier: "goToMyBook", sender: self)
            
        }else if indexPath.section == 2, indexPath.row == 0{ //공지사항
            performSegue(withIdentifier: "goToNotice", sender: self)
            
        }else if indexPath.section == 2, indexPath.row == 1{ //차단유저관리
            performSegue(withIdentifier: "goToManage", sender: self)
            
        }else if indexPath.section == 2, indexPath.row == 2{ //설정
            performSegue(withIdentifier: "goToSetting", sender: self)
            
        }else if indexPath.section == 2, indexPath.row == 3{ //로그아웃
            logoutPressed()
        }else{ //회원탈퇴
            userWithdrawalPressed()
        }

        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMyBook"{
            if let destinationVC = segue.destination as? MyBookViewController{
                guard let user = Auth.auth().currentUser else{return}
                guard let email = user.email else{return}
                
                destinationVC.userUid = user.uid
                destinationVC.userEmail = email
            }
        }
    }
}

    
   



