//
//  MyBookViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/15.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

final class MyBookViewController: UIViewController {
    
//MARK: - Properties
    private let db = Firestore.firestore()
    private var userModel : [UserModel] = []
    
    private var imageUrlArray : [String] = []
    
    var userUid : String?
    var userEmail : String?
    
    private var fetchingData : Bool = true
    private var lastSnapshotDocument : QueryDocumentSnapshot?
    
    private var nickNameDefaults : String = ""
    private var registerID : String = ""
    
    private lazy var sequenceButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "최신순", style: .done, target: self, action: nil)
        sb.isEnabled = false
        return sb
    }()
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(reloadAction), for: .valueChanged)
        
        return rf
    }()
    
    private let collectionHeader = UICollectionReusableView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        
        tabBarController?.tabBar.isHidden = true
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        viewChange()
        
        userAndBookDataUpdate()
        
        collectionView.refreshControl = refresh
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
        collectionView.register(CHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CHeaderView.headerIdenty)

        // Do any additional setup after loading the view.
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "회원도감"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = sequenceButton
        navigationItem.backBarButtonItem = backButton
    }
    
    private func viewChange(){
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaInsets)
            make.right.left.equalTo(view)
        }
        
        collectionView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.width.height.equalTo(100)
        }
        
    }
   
//MARK: - DataMethod
    private func userAndBookDataUpdate() {
        if let uid = userUid, let email = userEmail {
            
            self.userUpdate(uid: uid, userEmail: email)
            self.getUserBookUpdate(uid: uid)
        }
    }
    
    private func userUpdate(uid : String, userEmail : String) {
        
        db.collection("Users").document(uid).getDocument { snapshot, error in
            if let e = error {
                print("Error getdocument data \(e)")
            }else{
                guard let userData = snapshot?.data() else {return}//해당 도큐먼트 안에 데이터가 있는지 확인
                
                if let saveData = userData["NickName"] as? String{ //"NickName" 필드에 데이터가 있는지 확인
                    self.nickNameDefaults = saveData
                    self.registerID = userEmail
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
    }
    
    private func getUserBookUpdate(uid : String) {
        
        db.collection("전체보기").whereField("user", isEqualTo: uid).order(by: "date", descending: true).limit(to: 10).addSnapshotListener { querySnapshot, error in
            if let e = error {
                print("Error find data : \(e)")
            }else{
                self.userModel = []
                self.imageUrlArray = []
                
                if let snapshotDocuments = querySnapshot?.documents{ //도큐먼트 접근
                    guard let lastSnapshot = snapshotDocuments.last else {return}
                    self.lastSnapshotDocument = lastSnapshot
                    
                    for doc in snapshotDocuments{
                        
                        let data = doc.data() //도큐먼트 안에 데이터에 접근
                        
                        if let titleData = data["Title"] as? String, let segmentData = data["segment"] as? String, let userData = data["user"] as? String, let savedData = data["date"] as? String, let urlArrayData = data["url"] as? [String]{ //데이터들 string 형태로 가져와서 저장
                            
                            let findData = UserModel(title: titleData, segment: segmentData, userName: "", saveDate: savedData, userUid: userData)
                            
                            self.userModel.append(findData)
                            self.imageUrlArray.append(urlArrayData[0])
                            
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    private func getNextPageData(){
        guard let lastSnapshotDocumentId = lastSnapshotDocument else{return}
        guard let uid = userUid else {return}

        db.collection("전체보기").whereField("user", isEqualTo: uid).order(by: "date", descending: true).start(afterDocument: lastSnapshotDocumentId).limit(to: 10).addSnapshotListener { querySnapshot, error in
            if let e = error {
                print("Error find data : \(e)")
            }else{
                
                if let snapshotDocuments = querySnapshot?.documents{ //도큐먼트 접근
                    guard let lastSnapshot = snapshotDocuments.last else {return}
                    self.lastSnapshotDocument = lastSnapshot
                    self.indicatorView.startAnimating()
                    
                    for doc in snapshotDocuments{
                        
                        let data = doc.data() //도큐먼트 안에 데이터에 접근
                        
                        if let titleData = data["Title"] as? String, let segmentData = data["segment"] as? String, let userData = data["user"] as? String, let savedData = data["date"] as? String, let nickNameData = data["userNickName"] as? String, let urlArrayData = data["url"] as? [String]{ //데이터들 string 형태로 가져와서 저장
                            
                            let findData = UserModel(title: titleData, segment: segmentData, userName: nickNameData, saveDate: savedData, userUid: userData)
                            
                                self.userModel.append(findData)
                                self.imageUrlArray.append(urlArrayData[0])
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.fetchingData = true
                        self.indicatorView.stopAnimating()
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - EventMethod
    @objc private func reloadAction() {
        
        collectionView.reloadData()
        refresh.endRefreshing()
    }
    
    private func imageUploadFail() {
        let alert = UIAlertController(title: "이미지 다운로드 실패", message: "네트워크 확인 or 로딩 기다리기", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }


}

//MARK: - Extension
extension MyBookViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        
        let url = URL(string: imageUrlArray[indexPath.row]) //이미지 url이 저장되어 있는 배열에서 하나씩 가져오기.
        let processor = DownsamplingImageProcessor(size: CGSize(width: collectionView.frame.width / 2 - 1, height: 170)) //이미지뷰 크기에 맞게 이미지다운샘플링
        
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: url, placeholder: nil, options: [.processor(processor), .transition(.fade(0.7)), .cacheOriginalImage ]) { result in
            switch result{
            case .success(_):
                print("Done")
            case .failure(_):
                self.imageUploadFail()
            }
        }
        
        cell.titleLable.text = userModel[indexPath.row].title
        cell.difficultyLabel.text = "난이도: \(userModel[indexPath.row].segment)"
        cell.dateLabel.text = userModel[indexPath.row].saveDate
        cell.whoLabel.text = "작성자: \(nickNameDefaults)"
        cell.userUidLabel.text = userModel[indexPath.row].userUid

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedItem = collectionView.cellForItem(at: indexPath) as? CustomCell else{return}
        if let selectedDate = selectedItem.dateLabel.text{
            UserDefaults.standard.set(selectedDate, forKey: "selectedDate")
        }//데이터를 가져올때 제목이 중복되는 경우가 있을 수 있다. 따라서 날짜와 제목 모두 일치하는 정보를 가져올 수 있도록.
        
        if let selectedTitle = selectedItem.titleLable.text{
            UserDefaults.standard.set(selectedTitle, forKey: "selectedTitle")
        }//선택한 셀의 제목을 저장해두기
        
        if let userUID = selectedItem.userUidLabel.text{
            UserDefaults.standard.set(userUID, forKey: "userUID")
        }//user.uid가져오기
        
        self.performSegue(withIdentifier: "goToComunication", sender: self )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CHeaderView.headerIdenty, for: indexPath) as! CHeaderView
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            headerView.nickNameLabel.text = nickNameDefaults
            headerView.pImage.image = UIImage(named: "요리사")
            headerView.idLabel.text = registerID
            headerView.layer.borderColor = UIColor.customPink2?.cgColor
            headerView.layer.borderWidth = 3
            
            return headerView
        
        default :
            assert(false, "No")
        }
        
        return headerView
    }
    
    //위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    
    //옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            
        let width = collectionView.frame.width / 2 - 1
        
        let size = CGSize(width: width, height: 345)
        
        return size
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        let height : CGFloat = 100
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height{
            if fetchingData{
                if scrollView.contentSize.height != 0{
                    fetchingData = false
                    self.getNextPageData()
    
                }
            }
        }
    }
}




