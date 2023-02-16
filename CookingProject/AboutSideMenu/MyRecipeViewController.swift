//
//  MyRecipeViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/11.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher
import SCLAlertView

final class MyRecipeViewController: UIViewController {
//MARK: - Properties
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    private var recipeDataArray : [RecipeDataModel] = []
    
    final var myName = String() //내 이름정보.
    
    final var userName = String() //유저 닉네임정보.
    final var userUid = String()
    final var sequenceString = String()   //버튼의 타이틀을 시퀸스상태대로 변경하기 위함.
    
    private let myRecipeCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.backgroundColor = .clear
        cView.showsVerticalScrollIndicator = false
        
        return cView
    }()
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private lazy var deleteButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "trash", withConfiguration: imageConfig)
        
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.tintColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = .white
//        button.isHidden = true
        
        return button
    }()
    
    private var deleteModeState : Bool = false  //deleteMode인지 아닌지. 컬렉션뷰 셀을 누를 때 확인해서 모드에 따라 다른 서비스.
    private var deleteRecipeArray : [Int] = []
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomLoadingView.shared.startLoading(alpha: 0.5)
        
        checkUserState()
        checkSquenceState()
        
        addSubViews()
        naviBarAppearance()
        
        myRecipeCollectionView.delegate = self
        myRecipeCollectionView.dataSource = self
        myRecipeCollectionView.register(MyRecipeCollectionViewCell.self, forCellWithReuseIdentifier: MyRecipeCollectionViewCell.identifier)
        myRecipeCollectionView.register(MyRecipeHeaderCollectionReusableView.self,
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyRecipeHeaderCollectionReusableView.identifier)
        
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .customNavy
        
        self.navigationItem.backBarButtonItem = backButton
        
    }
    
    private func addSubViews(){
        view.backgroundColor = .customWhite
        
        view.addSubview(myRecipeCollectionView)
        myRecipeCollectionView.backgroundColor = .clear
        myRecipeCollectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        myRecipeCollectionView.addSubview(deleteButton)
        deleteButton.layer.masksToBounds = false
        deleteButton.layer.shadowOpacity = 0.7
        deleteButton.layer.shadowColor = UIColor.black.cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        deleteButton.layer.shadowRadius = 5
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).inset(-60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
    
    private func checkSquenceState() {
        if let state = UserDefaults.standard.string(forKey: "sequence") { //저장된 정렬 정보가 있으면 그것대로 정렬
            self.sequenceString = state
            sequencePressed(sequence: state)
            
        }else{//정렬 정보가 없으면 최신순.
            self.sequenceString = "최신순"
            let query = db.collection("전체보기").whereField(DataKeyWord.userUID, isEqualTo: self.userUid).order(by: "date", descending: true)
            getRecipeData(query: query)
        }
        
    }//UserDefaluts 정렬정보를 알아와서 정보가 있으면 정보에 맞게 버튼 타이틀변경, 없으면 최신순으로 버튼 타이틀 변경
    
    private func checkUserState() {
        if let user = Auth.auth().currentUser{ //먼저 로그인 체크.
            
            if userUid == user.uid { //현재 페이지의 유저정보와 내 정보를 비교.
                let deleteAction = UIAction(title: "삭제하기",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in self.deleteModeStart()})
                
                let menu = UIMenu(title: "", identifier: nil, options: .displayInline, children: [deleteAction])
                
                let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), primaryAction: .none, menu: menu)
                self.navigationItem.rightBarButtonItem = menuButton
                
            }else{
                let blockAction = UIAction(title: "차단하기", attributes: .destructive, handler: { _ in self.setBlockUser(myUID: user.uid, blockUserUID: self.userUid)})
                let reportAction = UIAction(title: "신고하기", attributes: .destructive, handler: { _ in self.goToReport()})
                
                let menu = UIMenu(title: "", identifier: nil, options: .displayInline, children: [blockAction, reportAction])
                
                let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), primaryAction: .none, menu: menu)
                self.navigationItem.rightBarButtonItem = menuButton
            }
            
        }else{
            self.navigationItem.rightBarButtonItem = .none
        }
    }//현재 페이지의 정보가 내정보인지 다른 유저의 정보인지 체크
    
//MARK: - ButtonMethod
    @objc private func deleteButtonPressed(_ sender : UIButton) {
        if deleteRecipeArray.count != 0 { //삭제할 레시피가 담겨있을 때만
            
            let appearence = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: FontKeyWord.CustomFont, size: 17) ?? .boldSystemFont(ofSize: 17), kTextFont: UIFont(name: FontKeyWord.CustomFont, size: 13) ?? .boldSystemFont(ofSize: 13), showCloseButton: false)
            let alert = SCLAlertView(appearance: appearence)
            
            alert.addButton("확인", backgroundColor: .customSignature, textColor: .white) {
                self.deleteRecipeData()
            }
            
            alert.addButton("취소", backgroundColor: .customSignature, textColor: .white) {
                
            }
            
            alert.showSuccess("삭제",
                              subTitle: "레시피를 삭제하시겠습니까?",
                              colorStyle: 0xFFB6B9,
                              colorTextButton: 0xFFFFFF)
        }
    }
    
}

//MARK: - DataMethod
    


//MARK: - Extension
extension MyRecipeViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyRecipeCollectionViewCell.identifier, for: indexPath) as! MyRecipeCollectionViewCell
        
        let url = recipeDataArray[indexPath.row].url //이미지 url이 저장되어 있는 배열에서 하나씩 가져오기.
        cell.foodImageView.setImage(with: url, width: 150, height: 150)
        
        cell.foodNameLable.text = recipeDataArray[indexPath.row].foodName
        cell.heartCountLabel.text = "\(recipeDataArray[indexPath.row].heartPeople.count)"
        cell.categoryLabel.text = recipeDataArray[indexPath.row].foodCategory
        cell.dateLabel.text = recipeDataArray[indexPath.row].writedDate
        
        if deleteRecipeArray.contains(indexPath.row) {
            cell.deleteModeCheckBox.isHidden = false
        }else{
            cell.deleteModeCheckBox.isHidden = true
        }
        
        return cell
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width / 2
        
        let size = CGSize(width: width, height: 285)
        
        return size
    }
    
    //headerview 등록
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyRecipeHeaderCollectionReusableView.identifier, for: indexPath) as! MyRecipeHeaderCollectionReusableView
            
            headerView.delegate = self
            headerView.sequenceString = self.sequenceString
            headerView.categoryLabel.text = "\(userName)님 레시피"
            headerView.subTitleLabel.text = "\(userName)님의 레시피를 \(sequenceString)서로 보여줍니다."
            headerView.countLabel.text = "전체 \(recipeDataArray.count)개"
            
            return headerView
            
        default:
            assert(false, "faile")
        }
    }
    
    //headerview height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 160
        return CGSize(width: width, height: height)
    }
}

extension MyRecipeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if deleteModeState { //deleteMode일 때,
            
            if deleteRecipeArray.contains(indexPath.row) { //배열에 들어가있으면? 삭제
                self.deleteRecipeArray = deleteRecipeArray.filter { $0 != indexPath.row}
                
            }else{// 배열에 없으면 추가.
                self.deleteRecipeArray.append(indexPath.row)
            }
            
            myRecipeCollectionView.reloadData()
            
        }else{ //아닐 때는 고냥 레시피로 이동.
            let vc = RecipeViewController()
            vc.myName = self.myName
            vc.recipeData = self.recipeDataArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//헤더에서 순서정렬버튼을 눌러 순서를 바꾼경우
extension MyRecipeViewController : MyRecipeHeaderViewDelegate {
    func changeSequence(title: String) {
        self.sequencePressed(sequence: title)
    }
}

//데이터 가져오기와, 데이터 가져오는 순서 정렬
extension MyRecipeViewController {
    private func sequencePressed(sequence : String) {
        switch sequence { //유저가 누른 순서 파악.
            
        case "최신순":
            //최신순서에 맞는 쿼리 조건 설정
            let query = db.collection("전체보기").whereField(DataKeyWord.userUID, isEqualTo: userUid).order(by: DataKeyWord.writedDate, descending: true)
            self.sequenceString = sequence  //버튼의 타이틀 변경용
            getRecipeData(query: query)
            UserDefaults.standard.set(sequence, forKey: "sequence")
            
        case "과거순":
            //과거순서에 맞는 쿼리 조건 설정
            let query = db.collection("전체보기").whereField(DataKeyWord.userUID, isEqualTo: userUid).order(by: DataKeyWord.writedDate, descending: false)
            self.sequenceString = sequence   //버튼의 타이틀 변경용
            getRecipeData(query: query)
            UserDefaults.standard.set(sequence, forKey: "sequence")
            
        default:
            //인기순서에 맞는 쿼리 조건 설정
            let query = db.collection("전체보기").whereField(DataKeyWord.userUID, isEqualTo: userUid).order(by: DataKeyWord.heartPeople, descending: true)
            self.sequenceString = sequence   //버튼의 타이틀 변경용
            getRecipeData(query: query)
            UserDefaults.standard.set(sequence, forKey: "sequence")
        }
    }

    private func getRecipeData(query : Query) {
        
        query.addSnapshotListener { qs, error in
            if let e = error {
                print("Error find data : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
                
            }else{
                self.recipeDataArray = []
                guard let snapshotDocuments = qs?.documents else{return} //도큐먼트들에 접근
                
                for doc in snapshotDocuments{
                    let data = doc.data()   //도큐먼트 안에 데이터에 접근
                    
                    guard let foodNameData = data[DataKeyWord.foodName] as? String else{return}
                    guard let userNameData = data[DataKeyWord.userName] as? String else{return}
                    guard let heartPeopleData = data[DataKeyWord.heartPeople] as? [String] else{return}
                    guard let levelData = data[DataKeyWord.foodLevel] as? String else{return}
                    guard let timeData = data[DataKeyWord.foodTime] as? String else{return}
                    guard let categoryData = data[DataKeyWord.foodCategory] as? String else{return}
                    guard let urlData = data[DataKeyWord.url] as? [String] else{return}
                    guard let dateData = data[DataKeyWord.writedDate] as? String else{return}
                    
                    let findData = RecipeDataModel(foodName: foodNameData, userName: userNameData, heartPeople: heartPeopleData, foodLevel: levelData, foodTime: timeData, writedDate: dateData, url: urlData[0], foodCategory: categoryData, documentID: doc.documentID)
                    
                    self.recipeDataArray.append(findData)
                }
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    self.myRecipeCollectionView.reloadData()
                    UIView.transition(with: self.myRecipeCollectionView, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
                }
            }
        }
    }
}


//차단, 신고, 삭제 기능.
extension MyRecipeViewController {
    private func setBlockUser(myUID : String, blockUserUID : String) {
        //내 차단유저 데이터 모음집에 추가.
        db.collection("\(myUID).block").addDocument(data: [DataKeyWord.userUID : blockUserUID,
                                                           DataKeyWord.userName: self.userName])
        
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    } //차단하기
    
    private func goToReport() {
        let vc = FeedBackViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    } //신고하기
    
    private func deleteModeStart() {
        self.deleteModeState = true
        let menuButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = menuButton
        
        self.deleteButton.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.deleteButton.transform = CGAffineTransform(translationX: 0, y: -100)
        })
        
    } //삭제하기를 눌렀을 때, 삭제모드로 돌입한다.
    
    //deletemode에서 다시 정상모드로 돌려주기.
    @objc private func cancelButtonPressed(_ sender : UIBarButtonItem) {
        self.deleteModeState = false
        
        let deleteAction = UIAction(title: "삭제하기",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in self.deleteModeStart()})
        
        let menu = UIMenu(title: "", identifier: nil, options: .displayInline, children: [deleteAction])
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), primaryAction: .none, menu: menu)
        self.navigationItem.rightBarButtonItem = menuButton
        
        self.deleteRecipeArray = []
        self.myRecipeCollectionView.reloadData()
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.deleteButton.transform = CGAffineTransform(translationX: 0, y: +100)
        }, completion: { _ in
            self.deleteButton.isHidden = true
        })
        
    } //삭제모드 취소를 눌렀을 때, 다시 원상복귀
    
}

//데이터 삭제
extension MyRecipeViewController {
    //레시피 데이터삭제
    private func deleteRecipeData() {
        CustomLoadingView.shared.startLoading(alpha: 0.5)
        
        for i in deleteRecipeArray {
            let document = recipeDataArray[i].documentID
            
            db.collection("전체보기").document(document).getDocument { qs, error in
                if let e = error {
                    print("Error 삭제 전 레시피 데이터 가져오기 실패 : \(e)")
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                    }
                }else{
                    if let data = qs?.data() {
                        
                        guard let imageFileNameData = data[DataKeyWord.imageFile] as? [String] else{return}
                        
                        self.deleteImageData(files: imageFileNameData)
                        self.deleteCommentsData(documentID: document)
                        self.db.collection("전체보기").document(document).delete()
                    }
                }
            }
            
        }
    }
    
    //이미지 데이터 삭제
    private func deleteImageData(files : [String]) {
        for i in files {
            
            let desertRef = storage.reference().child(i)
            
            desertRef.delete { error in
                if let e = error{
                    print("Error delete file : \(e)")
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                    }
                }else{
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                        self.deleteRecipeArray = []
                        self.myRecipeCollectionView.reloadData()
                        print("이미지 삭제완료.")
                    }
                }
            }
        }
    }
    
    //댓글 데이터 삭제.
    private func deleteCommentsData(documentID : String) {
        db.collection("전체보기").document(documentID).collection("댓글").getDocuments { qs, error in
            if let e = error{
                print("Error find message data : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                guard let snapShotDocuments = qs?.documents else{return}
                
                for doc in snapShotDocuments {
                    
                    self.db.collection("전체보기").document(documentID).collection("댓글").document(doc.documentID).delete()
                }
            }
        }
    }
    
}
