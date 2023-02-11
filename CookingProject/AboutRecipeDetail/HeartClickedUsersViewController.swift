//
//  HeartClikedUsersViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/11.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class HeartClickedUsersViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    final var delegate : HeartButtonClickedDelegate?   //좋아요 누르면 이전 뷰 좋아요 갯수 변경
    final var heartUserUidArray : [String] = [] //좋아요를 누른 유저들의 uid 모음.
    private var heartUserNameArray : [String] = []
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private lazy var heartButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(image: UIImage(systemName: "suit.heart.fill"), style: .done, target: self, action: #selector(heartButtonPressed(_:)))
        
        return sb
    }()
    
    private let heartUsersTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = .customSignature
        rf.addTarget(self, action: #selector(reloadAction(_:)), for: .valueChanged)
        
        return rf
    }()
    
    final var myName = String()
    final var documentID = String()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHeartUserName()
        addSubViews()
        naviBarAppearance()
        checkHeartState()
        
        heartUsersTableView.refreshControl = refresh
        heartUsersTableView.dataSource = self
        heartUsersTableView.delegate = self
        heartUsersTableView.register(HeartClickedUserTableViewCell.self, forCellReuseIdentifier: HeartClickedUserTableViewCell.identifier)
        heartUsersTableView.rowHeight = 75
        heartUsersTableView.separatorStyle = .none
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .customNavy
        
        navigationItem.title = "좋아요"
        self.navigationItem.largeTitleDisplayMode = .always
        navigationItem.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = heartButton
    }
    
    private func addSubViews() {
        view.backgroundColor = .customWhite
        
        view.addSubview(heartUsersTableView)
        heartUsersTableView.backgroundColor = .clear
        heartUsersTableView.showsVerticalScrollIndicator = false
        heartUsersTableView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    
    @objc private func reloadAction(_ sender : UIRefreshControl) {
        heartUsersTableView.reloadData()
        refresh.endRefreshing()
    }
    
    private func checkHeartState() {
        if let user = Auth.auth().currentUser{ //로그인 체크
            
            if heartUserUidArray.contains(user.uid) { //좋아요 눌려있다면?
                heartButton.image = UIImage(systemName: "suit.heart.fill")
                
            }else{ //좋아요 아직 안누른상태라면?
                heartButton.image = UIImage(systemName: "suit.heart")
            }
        }else{
            heartButton.image = .none
        }
    }//좋아요를 눌렀는지 안눌렀는지 체크.
    
//MARK: - ButtonMethod
    @objc private func dismissButtonPressed(_ sender : UIBarButtonItem) {
        self.dismiss(animated: true)
        
    }
    
    @objc private func heartButtonPressed(_ sender : UIBarButtonItem){
        guard let user = Auth.auth().currentUser else{return}
        
        if heartUserUidArray.contains(user.uid) { //이미 좋아요를 눌렀을 때,
            
            heartButton.image = UIImage(systemName: "suit.heart")
            heartUserUidArray = heartUserUidArray.filter { $0 != user.uid} //내 아이디 좋아요 리스트에서 삭제
            heartUserNameArray = heartUserNameArray.filter {$0 != myName}  //내 닉네임 좋아요 리스트에서 삭제
            heartUsersTableView.reloadData()
            updateHeartPeopleData()
            
        }else{ //좋아요를 안눌렀을 때,
            heartButton.image = UIImage(systemName: "suit.heart.fill")
            heartUserUidArray.append(user.uid)
            heartUserNameArray.append(myName)
            heartUsersTableView.reloadData()
            updateHeartPeopleData()
        }
        
        self.delegate?.clickedButton(heartUserData: heartUserUidArray)
    }
    
//MARK: - DataMethod
    private func updateHeartPeopleData() {
        let path = db.collection("전체보기").document(documentID)
        path.updateData(["heartPeople" : self.heartUserUidArray])
        
    }
    
    private func getHeartUserName() {
        CustomLoadingView.shared.startLoading(alpha: 0.5)
        var count = 0
        
        for i in heartUserUidArray {
            db.collection("Users").document(i).getDocument { qs, error in
                if let e = error{
                    print("Error 유저 닉네임 정보가져오기 실패 :\(e)")
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                    }
                }else{
                    
                    if let data = qs?.data() {
                        guard let nickNameData = data["NickName"] as? String else{return}
                        
                        self.heartUserNameArray.append(nickNameData)
                    }
                    
                    if count == self.heartUserUidArray.count - 1 { //반복문의 마지막을 찾아서 reload
                        DispatchQueue.main.async {
                            CustomLoadingView.shared.stopLoading()
                            self.heartUsersTableView.reloadData()
                        }
                    }else{
                        count += 1
                    }
                }
            }
        }
    }
}

//MARK: - Extension
extension HeartClickedUsersViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.heartUserNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeartClickedUserTableViewCell.identifier, for: indexPath) as! HeartClickedUserTableViewCell
        
        cell.nameLabel.text = heartUserNameArray[indexPath.row]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
}

extension HeartClickedUsersViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = OtherUserProfileViewController()
        vc.nickName = self.heartUserNameArray[indexPath.row]
        vc.userUid = self.heartUserUidArray[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

protocol HeartButtonClickedDelegate {
    func clickedButton(heartUserData : [String])
}
