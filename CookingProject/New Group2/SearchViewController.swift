//
//  SearchViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit
import Firebase
import FirebaseFirestore
import Kingfisher

class SearchViewController: UIViewController {
    //MARK: - Properties
    private var userModel : [UserModel] = []
    private var cutOffUserModel : [String] = []
    private let db = Firestore.firestore()
    
    private var imageUrlArray : [String] = []
    
    private lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "제목을 정확하게 입력해주세요"
        sb.delegate = self
        sb.tintColor = .black
        
        return sb
    }()
    
    private lazy var cancelButton : UIBarButtonItem = {
        let cb = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelAction(_:)))
        
        return cb
    }()
    
    private lazy var collectionView : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
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
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        searchBar.becomeFirstResponder()
        
        getBlockedUserData()
        viewChange()
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
    }
    
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    private func viewChange() {
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaInsets)
            make.right.left.equalTo(view).inset(0)
        }
        
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.height.equalTo(100)
        }
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
        
    private func getUserBookUpdate(_ text : String) {
        
        db.collection("전체보기").whereField("Title", isEqualTo: text).getDocuments { querySnapshot, error in
            if let e = error {
                print("Error find data : \(e)")
            }else{
                self.userModel = []
                self.imageUrlArray = []
                
                if let snapshotDocuments = querySnapshot?.documents{ //도큐먼트 접근
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
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.indicatorView.stopAnimating()
                    }
                }
            }
        }
    }
    
    private func imageUploadFail() {
        let alert = UIAlertController(title: "이미지 다운로드 실패", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    
//MARK: - ButtonMethod
    @objc func cancelAction(_ sender : UIBarButtonItem) {
        searchBar.resignFirstResponder()
    }
    
}

//MARK: - Extension
extension SearchViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let searchText = searchBar.text{
            self.userModel = []
            self.collectionView.reloadData()
            
            self.getUserBookUpdate(searchText)
        }
        
    }
}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
      
        let url = URL(string: imageUrlArray[indexPath.row]) //이미지 url이 저장되어 있는 배열에서 하나씩 가져오기.
        let processor = DownsamplingImageProcessor(size: CGSize(width: collectionView.frame.width / 2 - 1, height: 170)) //이미지뷰 크기에 맞게 이미지다운샘플링
        
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
    
    
}
