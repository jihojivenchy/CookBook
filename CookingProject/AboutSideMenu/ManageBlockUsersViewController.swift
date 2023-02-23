//
//  ManageBlockUsersViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/13.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import SCLAlertView

final class ManageBlockUsersViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    private var blockUserArray : [BlockUserModel] = [] //차단한유저 데이터모델
    
    private let blockUsersTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = .customSignature
        rf.addTarget(self, action: #selector(reloadAction(_:)), for: .valueChanged)
        
        return rf
    }()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBlockedUserData()
        addSubViews()
        naviBarAppearance()
        
        blockUsersTableView.refreshControl = refresh
        blockUsersTableView.dataSource = self
        blockUsersTableView.delegate = self
        blockUsersTableView.register(HeartClickedUserTableViewCell.self, forCellReuseIdentifier: HeartClickedUserTableViewCell.identifier)
        blockUsersTableView.rowHeight = 75
        blockUsersTableView.separatorStyle = .none
    }
    
    //MARK: - ViewMethod
    private func naviBarAppearance() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .customNavy
        
        navigationItem.title = "차단 관리"
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func addSubViews() {
        view.backgroundColor = .customWhite
        
        view.addSubview(blockUsersTableView)
        blockUsersTableView.backgroundColor = .clear
        blockUsersTableView.showsVerticalScrollIndicator = false
        blockUsersTableView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    @objc private func reloadAction(_ sender : UIRefreshControl) {
        blockUsersTableView.reloadData()
        refresh.endRefreshing()
    }
    
//MARK: - ButtonMethod
    
    
    
//MARK: - DataMethod
    private func getBlockedUserData() {
        guard let user = Auth.auth().currentUser else{return}
        CustomLoadingView.shared.startLoading()
        
        db.collection("\(user.uid).block").addSnapshotListener { qs, error in
            if let e = error {
                print("Error 차단 유저 데이터 가져오기 실패 : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
                
            }else{
                self.blockUserArray = []
                guard let snapShotDocuments = qs?.documents else{return}
                
                for doc in snapShotDocuments{
                    let data = doc.data()
                    
                    guard let userUIDData = data[DataKeyWord.userUID] as? String else{return}
                    guard let userNameData = data[DataKeyWord.userName] as? String else{return}
                    
                    let findData = BlockUserModel(userUID: userUIDData, userName: userNameData, documentID: doc.documentID)
                    
                    self.blockUserArray.append(findData)
                }
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    self.blockUsersTableView.reloadData()
                }
            }
        }
    } //차단한 유저 가져오기.
}

//MARK: - Extension
extension ManageBlockUsersViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blockUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeartClickedUserTableViewCell.identifier, for: indexPath) as! HeartClickedUserTableViewCell
        
        cell.nameLabel.text = self.blockUserArray[indexPath.row].userName
        cell.accessoryType = .disclosureIndicator
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
}

extension ManageBlockUsersViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.cancelBlockAlert(index: indexPath.row)
    }
}

//차단 풀기.
extension ManageBlockUsersViewController {
    private func cancelBlockAlert(index : Int) {
        let appearence = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: FontKeyWord.CustomFont, size: 17) ?? .boldSystemFont(ofSize: 17), kTextFont: UIFont(name: FontKeyWord.CustomFont, size: 13) ?? .boldSystemFont(ofSize: 13), showCloseButton: false)
        let alert = SCLAlertView(appearance: appearence)
        
        alert.addButton("확인", backgroundColor: .customSignature, textColor: .white) {
            let documentID = self.blockUserArray[index].documentID
            self.deleteBlockUser(documentID: documentID)
        }
        
        alert.addButton("취소", backgroundColor: .customSignature, textColor: .white) {
            
        }
        
        alert.showSuccess("차단 해제",
                          subTitle: "\(self.blockUserArray[index].userName)님 차단을 해제하시겠습니까?",
                          colorStyle: 0xFFB6B9,
                          colorTextButton: 0xFFFFFF)
    }
    
    private func deleteBlockUser(documentID : String) {
        guard let user = Auth.auth().currentUser else{return}
        db.collection("\(user.uid).block").document(documentID).delete()
    }
}
