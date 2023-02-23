//
//  SignalViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/10.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class ManageNotificationViewController : UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    private var manageNotiDataArray : [ManageNotificationModel] = []
    private var blockUserArray : [String] = []
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(reloadAction), for: .valueChanged)
        rf.tintColor = .customSignature
        
        return rf
    }()
    
    private let notiTableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBlockedUserData()
        getNotificationData()
        naviBarAppearance()
        addSubViews()
        
        notiTableView.refreshControl = refresh
        notiTableView.dataSource = self
        notiTableView.delegate = self
        notiTableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identifier)
        notiTableView.rowHeight = 100
        notiTableView.separatorStyle = .none
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        self.navigationItem.backBarButtonItem = backButton
        navigationItem.title = "알림"
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func addSubViews() {
        view.backgroundColor = .customWhite
        
        view.addSubview(notiTableView)
        notiTableView.backgroundColor = .clear
        notiTableView.showsVerticalScrollIndicator = false
        notiTableView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
   
    @objc private func reloadAction() {
        refresh.endRefreshing()
    }
    
//MARK: - ButtonMethod
    @objc private func homeButtonPressed(_ sender : UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc private func plusButtonPressed(_ sender : UIButton) {
        if Auth.auth().currentUser != nil {
            let vc = CategoryViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            CustomAlert.show(title: "로그인", subMessage: "로그인이 필요한 서비스입니다.")
        }
    }
    
    @objc private func bellButtonPressed(_ sender : UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
}

//MARK: - Extension
extension ManageNotificationViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.manageNotiDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as! NotificationTableViewCell
        
        let notiData = manageNotiDataArray[indexPath.row]
        
        if notiData.version == 0 {
            cell.titleLabel.text = "회원님의 레시피에 댓글이 달렸습니다."
            cell.subTitleLabel.text = "\(notiData.userName)님의 댓글 \"\(notiData.comment)\""
            cell.dateLabel.text = notiData.writedDate
            
        }else{
            cell.titleLabel.text = "회원님의 댓글에 답글이 달렸습니다."
            cell.subTitleLabel.text = "\(notiData.userName)님의 답글 \"\(notiData.comment)\""
            cell.dateLabel.text = notiData.writedDate
        }
        
        return cell
    }
}

extension ManageNotificationViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
        
        let vc = RecipeViewController()
        vc.recipeDocumentID = self.manageNotiDataArray[indexPath.row].recipeDocumentID
        vc.goToComment = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //cell들을 편집할 수 있도록.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // All rows are editable
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            self.deleteNotiData(index: indexPath.row)
            completion(true)
        }
        deleteAction.backgroundColor = .red
        let trashImage = UIImage(systemName: "trash") // Replace with the name of your trash image asset
        deleteAction.image = trashImage
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

//MARK: - DataMethod
extension ManageNotificationViewController {
    
    private func getBlockedUserData() {
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("\(user.uid).block").addSnapshotListener { querySnapshot, error in
            if let e = error{
                print("Error 차단한 유저 데이터 가져오기 실패 : \(e)")
            }else{
                guard let snapShotDocuments = querySnapshot?.documents else{return}
                
                for doc in snapShotDocuments{
                    let data = doc.data()
                    
                    if let userUID = data[DataKeyWord.userUID] as? String{
                        self.blockUserArray.append(userUID)
                    }
                }
            }
        }
    }//차단한 유저 데이터 가져오기.
    
    private func getNotificationData() {
        CustomLoadingView.shared.startLoading()
        
        if let user = Auth.auth().currentUser {
            db.collection("\(user.uid).Noti").order(by: DataKeyWord.writedDate, descending: true).addSnapshotListener { qs, error in
                if let e = error{
                    print("Error 유저 알림 정보 가져오기 실패 : \(e)")
                }else{
                    self.manageNotiDataArray = []
                    guard let snapShotDocuments = qs?.documents else{return}
                    
                    for doc in snapShotDocuments {
                        let data = doc.data()
                       
                        guard let userUIDData = data[DataKeyWord.userUID] as? String else{return}
                        guard let userNameData = data[DataKeyWord.userName] as? String else{return}
                        guard let commentData = data[DataKeyWord.comment] as? String else{return}
                        guard let dateData = data[DataKeyWord.writedDate] as? String else{return}
                        guard let recipeData = data["recipeDocumentID"] as? String else{return}
                        guard let versionData = data["version"] as? Int else{return}
                        
                        if self.blockUserArray.contains(userUIDData){ //가져온 데이터가 차단한 유저라면 추가하지 않음.
                        }else{
                            let findData = ManageNotificationModel(userName: userNameData, comment: commentData, recipeDocumentID: recipeData, notiDocumentID: doc.documentID, writedDate: dateData, version: versionData)
                            
                            self.manageNotiDataArray.append(findData)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                        self.notiTableView.reloadData()
                        UIView.transition(with: self.notiTableView, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
                    }
                }
            }
            
            
        }else{
            CustomLoadingView.shared.stopLoading()
        }
    }
}

//deleteMethod
extension ManageNotificationViewController {
    private func deleteNotiData(index : Int){
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("\(user.uid).Noti").document(self.manageNotiDataArray[index].notiDocumentID).delete()
        
        //데이터 배열에 아무것도 남지 않으면 리로드를 해줘야한다. 여러 개 있을 때는 알아서 갱신됨. 결론 두번씩 reload해줄필요가없다.
        if manageNotiDataArray.count == 1 {
            self.manageNotiDataArray.remove(at: index)
            self.notiTableView.reloadData()
            UIView.transition(with: self.notiTableView, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        }
        
    }
}
