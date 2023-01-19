//
//  SnakViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/18.
//

import UIKit
import Firebase
import FirebaseFirestore
import Kingfisher

class SnakViewController : UIViewController {
    private let db = Firestore.firestore()
    private var userModel : [UserModel] = []
    private var cutOffUserModel : [String] = []
    
    private var imageUrlArray : [String] = []
    
    private var fetchingData : Bool = true
    private var lastSnapshotDocument : QueryDocumentSnapshot?
    
    
    private lazy var collectionView : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(reloadAction), for: .valueChanged)
        
        return rf
    }()
    
    private lazy var indicatorView : UIActivityIndicatorView = {
       let ia = UIActivityIndicatorView()
        ia.hidesWhenStopped = true
        ia.style = .large
        
        return ia
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewChange()
        getUserBookUpdate()

        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
        collectionView.refreshControl = refresh
    }
    
    //MARK: - ViewMethod
    private func viewChange() {
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
    
    private func getUserBookUpdate() {
        getBlockedUserData()
        
        db.collection("전체보기").whereField("tema", isEqualTo: "간식").order(by: "date", descending: true).limit(to: 10).addSnapshotListener { querySnapshot, error in
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
                        
                        if let titleData = data["Title"] as? String, let segmentData = data["segment"] as? String, let userData = data["user"] as? String, let savedData = data["date"] as? String, let nickNameData = data["userNickName"] as? String, let urlArrayData = data["url"] as? [String]{ //데이터들 string 형태로 가져와서 저장
                            
                            let findData = UserModel(title: titleData, segment: segmentData, userName: nickNameData, saveDate: savedData, userUid: userData)
                            
                            if self.cutOffUserModel.contains(userData){ //가져온 데이터가 차단한 유저라면 추가하지 않음.
                            }else{
                                self.userModel.append(findData)
                                self.imageUrlArray.append(urlArrayData[0])
                            }
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
        
        db.collection("전체보기").whereField("tema", isEqualTo: "간식").order(by: "date", descending: true).start(afterDocument: lastSnapshotDocumentId).limit(to: 10).addSnapshotListener { querySnapshot, error in
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
                            
                            if self.cutOffUserModel.contains(userData){ //가져온 데이터가 차단한 유저라면 추가하지 않음.
                            }else{
                                self.userModel.append(findData)
                                self.imageUrlArray.append(urlArrayData[0])
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.indicatorView.stopAnimating()
                        self.fetchingData = true
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }

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


extension SnakViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
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
            case .success(let value):
                print("Done : \(value)")
            case .failure(_):
                self.imageUploadFail()
            }
        }
        
        
        cell.titleLable.text = userModel[indexPath.row].title
        cell.whoLabel.text = "작성자: \(userModel[indexPath.row].userName)"
        cell.difficultyLabel.text = "난이도: \(userModel[indexPath.row].segment)"
        cell.dateLabel.text = userModel[indexPath.row].saveDate
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
    
    //퍼포먼스 상승
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        cell.imageView.kf.cancelDownloadTask()
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
