////
////  DetailViewController.swift
////  CookingProject
////
////  Created by 엄지호 on 2022/07/22.
////
//
//import UIKit
//import SnapKit
//import Firebase
//import FirebaseFirestore
//import Kingfisher
//
//class DetailViewController: UIViewController {
//    
////MARK: - Properties
//    private let db = Firestore.firestore()
//    
//    private let scrollView = UIScrollView()
//    
//    private let inCollectionView = UIView()
//    private let whoView = UIView()
//    private let whoImageView = UIImageView()
//    private let dateLabel = UILabel()
//    private let titleLabel = UILabel()
//    private let segmentLabel = UILabel()
//    private let temaLabel = UILabel()
//    private let whoLabel = UILabel()
//    private let ingredientLabel = UILabel()
//    private let contentsLabel = UILabel()
//    
//    private var userData : String = ""
//    private var userEmail : String = ""
//    
//    private lazy var ingredientsTextView : UITextView = {
//        let tv = UITextView()
//        tv.isEditable = false
//        tv.returnKeyType = .next
//        tv.layer.masksToBounds = true
//        tv.layer.cornerRadius = 10
//        tv.layer.borderWidth = 1
//        tv.layer.borderColor = UIColor.customGray?.cgColor
//        tv.font = .systemFont(ofSize: 20, weight: .black)
//        tv.textColor = .black
//        tv.isEditable = false
//
//        return tv
//    }()
//    
//    private lazy var contentsTextView : UITextView = {
//        let ct = UITextView()
//        ct.isEditable = false
//        ct.returnKeyType = .next
//        ct.layer.masksToBounds = true
//        ct.layer.cornerRadius = 10
//        ct.layer.borderWidth = 1
//        ct.layer.borderColor = UIColor.customGray?.cgColor
//        ct.font = .systemFont(ofSize: 20, weight: .black)
//        ct.textColor = .black
//        
//        return ct
//    }()
//    
//    private lazy var collectionView : UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        flowLayout.minimumInteritemSpacing = 0
//        flowLayout.itemSize = CGSize(width: view.frame.width, height: 410)
//        
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        cv.delegate = self
//        cv.dataSource = self
//        cv.backgroundColor = .white
//        cv.indicatorStyle = .white
//        cv.isPagingEnabled = true
//        
//        return cv
//    }()
//    
//    private var imageUrlArray : [String] = []
//    private var sendUrlArray : [String] = []
//    
//    private var indexNumber = 0
//    
////MARK: - LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        viewChange()
//        getSavedData()
//        
//        collectionView.register(WritePhotoCollectionViewCell.self, forCellWithReuseIdentifier: WritePhotoCollectionViewCell.identifier)
//
//    }
//    
//
//    
////MARK: - ViewMethod
//    private func viewChange() {
//        
//        view.backgroundColor = .white
//        
//        view.addSubview(scrollView)
//        scrollView.backgroundColor = .white
//        scrollView.snp.makeConstraints { make in
//            make.top.bottom.equalTo(view.safeAreaInsets)
//            make.left.right.equalTo(view)
//        }
//        
//        scrollView.addSubview(whoView)
//        whoView.backgroundColor = .white
//        whoView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaInsets)
//            make.right.left.equalTo(view)
//            make.height.equalTo(100)
//        }
//        
//        whoView.addSubview(whoImageView)
//        whoImageView.image = UIImage(named: "요리사")
//        whoImageView.layer.cornerRadius = 40 / 2
//        whoImageView.layer.borderWidth = 1
//        whoImageView.layer.borderColor = UIColor.customPink?.cgColor
//        whoImageView.clipsToBounds = true
//        whoImageView.snp.makeConstraints { make in
//            make.top.equalTo(whoView).inset(30)
//            make.left.equalTo(whoView).inset(15)
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//        }
//        
//        whoView.addSubview(whoLabel)
//        whoLabel.textColor = .black
//        whoLabel.font = UIFont(name: "EF_Diary", size: 23)
//        whoLabel.snp.makeConstraints { make in
//            make.top.equalTo(whoView).inset(30)
//            make.left.equalTo(whoImageView.snp_rightMargin).offset(20)
//            make.right.equalTo(whoView)
//            make.height.equalTo(30)
//        }
//        
//        whoView.addSubview(dateLabel)
//        dateLabel.textColor = .customPink
//        dateLabel.font = UIFont(name: "EF_Diary", size: 12)
//        dateLabel.snp.makeConstraints { make in
//            make.top.equalTo(whoLabel.snp_bottomMargin).offset(10)
//            make.left.equalTo(whoImageView.snp_rightMargin).offset(20)
//            make.right.equalTo(whoView)
//            make.height.equalTo(13)
//        }
//
//        
//        scrollView.addSubview(inCollectionView)
//        inCollectionView.backgroundColor = .white
//        inCollectionView.layer.borderWidth = 1
//        inCollectionView.layer.borderColor = UIColor.customGray?.cgColor
//        inCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(whoView.snp_bottomMargin).offset(30)
//            make.right.left.equalTo(view)
//            make.height.equalTo(410)
//        }
//        
//        inCollectionView.addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.top.bottom.equalTo(inCollectionView)
//            make.right.left.equalTo(view)
//        }
//        
//        scrollView.addSubview(titleLabel)
//        titleLabel.textColor = .black
//        titleLabel.font = UIFont(name: "EF_Diary", size: 30)
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(inCollectionView.snp_bottomMargin).offset(20)
//            make.left.equalTo(scrollView).inset(10)
//            make.right.equalTo(scrollView)
//            make.height.equalTo(30)
//        }
//        
//        scrollView.addSubview(temaLabel)
//        temaLabel.textColor = .black
//        temaLabel.font = UIFont(name: "EF_Diary", size: 17)
//        temaLabel.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp_bottomMargin).offset(40)
//            make.left.equalTo(scrollView).inset(12)
//            make.right.equalTo(scrollView)
//            make.height.equalTo(30)
//        }
//        
//        scrollView.addSubview(segmentLabel)
//        segmentLabel.textColor = .black
//        segmentLabel.font = UIFont(name: "EF_Diary", size: 17)
//        segmentLabel.snp.makeConstraints { make in
//            make.top.equalTo(temaLabel.snp_bottomMargin).offset(20)
//            make.left.equalTo(scrollView).inset(12)
//            make.right.equalTo(scrollView)
//            make.height.equalTo(30)
//            
//        }
//        
//        scrollView.addSubview(ingredientLabel)
//        ingredientLabel.text = "재료"
//        ingredientLabel.textColor = .black
//        ingredientLabel.font = UIFont(name: "EF_Diary", size: 23)
//        ingredientLabel.snp.makeConstraints { make in
//            make.top.equalTo(segmentLabel.snp_bottomMargin).offset(50)
//            make.left.equalTo(scrollView).inset(10)
//            make.right.equalTo(scrollView)
//            make.height.equalTo(30)
//        }
//        
//        scrollView.addSubview(ingredientsTextView)
//        ingredientsTextView.snp.makeConstraints { make in
//            make.top.equalTo(ingredientLabel.snp_bottomMargin).offset(20)
//            make.left.right.equalTo(view).inset(10)
//            make.height.equalTo(250)
//        }
//        
//        scrollView.addSubview(contentsLabel)
//        contentsLabel.text = "조리과정"
//        contentsLabel.textColor = .black
//        contentsLabel.font = UIFont(name: "EF_Diary", size: 23)
//        contentsLabel.snp.makeConstraints { make in
//            make.top.equalTo(ingredientsTextView.snp_bottomMargin).offset(50)
//            make.left.equalTo(scrollView).inset(10)
//            make.right.equalTo(scrollView)
//            make.height.equalTo(30)
//        }
//        
//        scrollView.addSubview(contentsTextView)
//        contentsTextView.snp.makeConstraints { make in
//            make.top.equalTo(contentsLabel.snp_bottomMargin).offset(20)
//            make.left.right.equalTo(view).inset(10)
//            make.height.equalTo(450)
//            make.bottom.equalTo(scrollView).inset(100)
//        }
//        
//        
//        
//    }
//    
//    private func setupLabelGesture() {
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(labelCliked(_:)))
//        whoLabel.isUserInteractionEnabled = true
//        whoLabel.addGestureRecognizer(gesture)
//    }
//    
//    @objc private func labelCliked(_ sender : UITapGestureRecognizer) {
//        performSegue(withIdentifier: "detailToMy", sender: self)
//    }
//    
////MARK: - DataMethod
//    private func getSavedData() {
//        guard let savedDate = UserDefaults.standard.string(forKey: "selectedDate") else{return}
//        
//        if let savedTitle = UserDefaults.standard.string(forKey: "selectedTitle"){
//            
//            db.collection("전체보기").whereField("Title", isEqualTo: savedTitle).whereField("date", isEqualTo: savedDate).getDocuments { querySnapshot, error in
//                if let e = error {
//                    print("Error find data : \(e)")
//                }else{
//                    self.imageUrlArray = []
//                    self.sendUrlArray = []
//                    
//                    if let snapshotDocuments = querySnapshot?.documents{
//                        
//                        for doc in snapshotDocuments{
//                            let data = doc.data()
//                            
//                            if let titleData = data["Title"] as? String,                     //제목
//                               let segmentData = data["segment"] as? String,                //난이도
//                               let userData = data["user"] as? String,                      //글주인 uid
//                               let userEmailData = data["userEmail"] as? String,            //글주인 email
//                               let ingredientData = data["ingredients"] as? String,         //재료
//                               let temaData = data["tema"] as? String,                      //테마
//                               let contentsData = data["contents"] as? String,              //조리과정
//                               let dateData = data["date"] as? String,                      //날짜
//                               let urlData = data["url"] as? [String]{                      //이미지 url
//                                
//                                self.getUserNickNameAndUpdate(titleData: titleData, segementData: segmentData, ingredientData: ingredientData, temaData: temaData, userData: userData, dateData: dateData, contentsData: contentsData)
//                                
//                                self.userData = userData
//                                self.userEmail = userEmailData
//                                
//                                self.imageUrlArray = urlData
//                                self.sendUrlArray = urlData
//                            }
//                        }
//                        DispatchQueue.main.async {
//                            self.collectionView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//    }
//        
//    private func getUserNickNameAndUpdate(titleData : String, segementData : String, ingredientData : String, temaData : String, userData : String, dateData : String, contentsData : String ) {
//        
//        db.collection("Users").document(userData).getDocument { snapshot, error in
//            if let error = error{
//                print("Error user nickname find : \(error)")
//            }else{
//                guard let userData = snapshot?.data() else {return}
//                
//                if let user = userData["NickName"] as? String{
//                    
//                    self.titleLabel.text = titleData
//                    self.segmentLabel.text = "난이도 : \(segementData)"
//                    self.ingredientsTextView.text = ingredientData
//                    self.temaLabel.text = "테마 : \(temaData)"
//                    self.whoLabel.text = user
//                    self.dateLabel.text = dateData
//                    self.contentsTextView.text = contentsData
//                    
//                    self.setupLabelGesture()
//                }
//            }
//        }
//    }// 글쓴이의 uid를 받아와서 저장되어있는 닉네임을 가져오고 세팅
//    
//    private func imageUploadFail() {
//        let alert = UIAlertController(title: "이미지 다운로드 실패", message: nil, preferredStyle: .alert)
//        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
//        
//        alert.addAction(alertAction)
//        present(alert, animated: true, completion: nil)
//    }
//    
//}
//
////MARK: - Extension
//extension DetailViewController : UICollectionViewDataSource{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageUrlArray.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WritePhotoCollectionViewCell.identifier, for: indexPath) as! WritePhotoCollectionViewCell
//        
//        guard let url = URL(string: imageUrlArray[indexPath.row]) else{return cell}
//        
//        let processor = DownsamplingImageProcessor(size: CGSize(width: collectionView.frame.width, height: collectionView.frame.height )) //이미지뷰 크기에 맞게 이미지다운샘플링
//       
//        cell.imageView.kf.indicatorType = .activity
//        cell.imageView.kf.setImage(with: url, placeholder: nil, options: [.processor(processor), .transition(.fade(0.7)), .cacheOriginalImage ]) { result in
//            switch result{
//            case .success(let value):
//                print("Done : \(value)")
//            case .failure(_):
//                self.imageUploadFail() //image upload에 실패했을 때
//            }
//        }
//        
//        
//        return cell
//    }
//    
//    
//}
//
//extension DetailViewController : UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.indexNumber = indexPath.item
//        performSegue(withIdentifier: "goToSeleted", sender: self)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToSeleted" {
//            if let detinationVC = segue.destination as? SelectedImageViewController{
//                detinationVC.urlDataArray = self.sendUrlArray
//                detinationVC.indexPathNumber = self.indexNumber
//            }
//        }else{
//            if let detinationVC = segue.destination as? MyBookViewController{
//                detinationVC.userUid = self.userData
//                detinationVC.userEmail = self.userEmail
//            }
//        }
//        
//    }
//    
//}
//
//extension DetailViewController : UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            0
//        }
//        
//        //section 사이의 공간을 제거
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            0
//        }
//    
//}
//
//
