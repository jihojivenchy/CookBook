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

final class SignalViewController : UIViewController {
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
    
    private lazy var homeButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .default)
        let image = UIImage(systemName: "house", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = "홈"
        configuration.attributedTitle?.font = UIFont(name: KeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.addTarget(self, action: #selector(homeButtonPressed(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }() //customTabbar용
    
    private lazy var plusButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = "작성"
        configuration.attributedTitle?.font = UIFont(name: KeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.addTarget(self, action: #selector(plusButtonPressed(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }() //customTabbar용
    
    private lazy var bellButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .default)
        let image = UIImage(systemName: "bell", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = "알림"
        configuration.attributedTitle?.font = UIFont(name: KeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.addTarget(self, action: #selector(bellButtonPressed(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }() //customTabbar용
    
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil{
            userSignalModel = []
            tableView.reloadData()
        }
        
        getSignalDataUpdate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCustomTabButton()
        addSubViews()
        
        tableView.refreshControl = refresh
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.cellName)
        tableView.rowHeight = 80

        
    }
//MARK: - ViewMethod
    
    
    private func addSubViews() {
        
        view.backgroundColor = .customSignature
        
        view.addSubview(tableView)
        tableView.backgroundColor = .customWhite
        tableView.showsVerticalScrollIndicator = false
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 30
        tableView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaInsets)
            make.bottom.equalTo(view.safeAreaInsets).inset(80)
        }
    }
    
    private func setCustomTabButton() {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaInsets).inset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
        
        stackView.addArrangedSubview(homeButton)
        stackView.addArrangedSubview(plusButton)
        stackView.addArrangedSubview(bellButton)
        
    }//탭바 안쓰고 이거 쓸거임.
    
    @objc private func reloadAction() {
        refresh.endRefreshing()
    }
    
//MARK: - ButtonMethod
    @objc private func homeButtonPressed(_ sender : UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc private func plusButtonPressed(_ sender : UIButton) {
        let vc = CategoryViewController()
//        vc.userName = self.userInformationData.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func bellButtonPressed(_ sender : UIButton) {
        self.tabBarController?.selectedIndex = 1
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


