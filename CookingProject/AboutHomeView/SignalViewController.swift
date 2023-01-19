//
//  SignalViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/10.
//

import UIKit
import SnapKit
import Firebase
import FirebaseFirestore

class SignalViewController : UIViewController {
//MARK: - Properties
    let db = Firestore.firestore()
    var userSignalModel : [UserSignalModel] = []
    private var cutOffUserModel : [String] = []
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(reloadAction), for: .valueChanged)
        
        return rf
    }()
    
    private let tableView = UITableView()
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private lazy var indicatorView : UIActivityIndicatorView = {
       let ia = UIActivityIndicatorView()
        ia.hidesWhenStopped = true
        ia.style = .large
        
        return ia
    }()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil{
            userSignalModel = []
            tableView.reloadData()
        }
        
        getSignalDataUpdate()
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        navigationTitleCustom()
        
        viewChange()
        
        tableView.refreshControl = refresh
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.cellName)
        tableView.rowHeight = 80

        
    }
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.backBarButtonItem = backButton
    }
    
    private func viewChange() {
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets)
            make.right.left.equalTo(view)
            make.bottom.equalToSuperview()
        }
        
        tableView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(100)
        }
    }
    
    private func navigationTitleCustom() {
        let titleName = UILabel()
        titleName.text = "알림"
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
        refresh.endRefreshing()
    }
    
//MARK: - DataMethod
    
    private func getBlockedUserData() {
        if let user = Auth.auth().currentUser{
            db.collection("\(user.uid).self").addSnapshotListener { querySnapshot, error in
                if let e = error{
                    print("Error find Cut-Off User Data : \(e)")
                }else{
                    if let snapShotDocuments = querySnapshot?.documents{
                        for doc in snapShotDocuments{
                            let data = doc.data()
                            if let userUid = data["user"] as? String{
                                
                                self.cutOffUserModel.append(userUid)
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getSignalDataUpdate() {
        getBlockedUserData()
        
        if let user = Auth.auth().currentUser{
            db.collection(user.uid).order(by: "date", descending: true).addSnapshotListener { querySnapshot, error in
                if let e = error{
                    print("Error user.uid collection find data : \(e)")
                }else{
                    self.indicatorView.startAnimating()
                    self.userSignalModel = []
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            
                            if let titleData = data["Title"] as? String, let senderData = data["sendedUser"] as? String, let ownerData = data["ownerUser"] as? String, let dateData = data["date"] as? String, let writedDateData = data["writedDate"] as? String, let nickNameData = data["userNickName"] as? String{
                                
                                let findDataModel = UserSignalModel(title: titleData, senderUser: senderData, ownerUser: ownerData, date: dateData, writedDate: writedDateData, nickName: nickNameData)
                                
                                if self.cutOffUserModel.contains(senderData){ //가져온 데이터가 차단한 유저라면 추가하지 않음.
                                }else{
                                    self.userSignalModel.append(findDataModel)
                                }
                                
                            }
                        }
                        DispatchQueue.main.async {
                            self.indicatorView.stopAnimating()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: - Extension
extension SignalViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSignalModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.cellName, for: indexPath) as! NotificationCell
        cell.labelImage.image = UIImage(named: "요리사")
        cell.cellLabel.text = "\(userSignalModel[indexPath.row].nickName)님께서 회원님의 \"\(userSignalModel[indexPath.row].title)\" 글에 댓글을 남겼습니다."
        cell.timeLabel.text = userSignalModel[indexPath.row].date
        cell.titleLabel.text = userSignalModel[indexPath.row].title
        cell.writeDateLabel.text = userSignalModel[indexPath.row].writedDate
        
        
        return cell
    }
}

extension SignalViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = tableView.cellForRow(at: indexPath) as? NotificationCell else{return}
        if let selectedDate = selectedItem.writeDateLabel.text{
            UserDefaults.standard.set(selectedDate, forKey: "selectedDate")
        }//데이터를 가져올때 제목이 중복되는 경우가 있을 수 있다. 따라서 날짜와 제목 모두 일치하는 정보를 가져올 수 있도록.
        
        if let selectedTitle = selectedItem.titleLabel.text{
            UserDefaults.standard.set(selectedTitle, forKey: "selectedTitle")
            if let user = Auth.auth().currentUser{
                UserDefaults.standard.set(user.uid, forKey: "userUID")
                self.performSegue(withIdentifier: "goToComunication", sender: self )
            }
        
        }
        
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
    }
}


