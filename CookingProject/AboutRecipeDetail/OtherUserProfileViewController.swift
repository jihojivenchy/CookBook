//
//  OtherUserProfileViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/11.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

final class OtherUserProfileViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    private var recipeDataArray : [RecipeDataModel] = []
    
    final var nickName = String()
    final var userUid = String()
    final var sequenceString = String()   //버튼의 타이틀을 시퀸스상태대로 변경하기 위함.
    
    private let otherRecipeCollectionView : UICollectionView = {
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
    
    private lazy var menuButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .done, target: self, action: #selector(menuButtonPressed(_:)))
        
        return sb
    }()
    
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomLoadingView.shared.startLoading(alpha: 0.5)
        
        checkSquenceState()
        
        addSubViews()
        naviBarAppearance()
        
        otherRecipeCollectionView.delegate = self
        otherRecipeCollectionView.dataSource = self
        otherRecipeCollectionView.register(MyRecipeCollectionViewCell.self, forCellWithReuseIdentifier: MyRecipeCollectionViewCell.identifier)
        otherRecipeCollectionView.register(MyRecipeHeaderCollectionReusableView.self,
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
        
        view.addSubview(otherRecipeCollectionView)
        otherRecipeCollectionView.backgroundColor = .clear
        otherRecipeCollectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
//MARK: - ButtonMethod
    @objc private func menuButtonPressed(_ sender : UIBarButtonItem) {
        
    }
    
//MARK: - DataMethod
    private func checkSquenceState() {
        if let state = UserDefaults.standard.string(forKey: "sequence") { //저장된 정렬 정보가 있으면 그것대로 정렬
            self.sequenceString = state
            sequencePressed(sequence: state)
            
        }else{//정렬 정보가 없으면 최신순.
            self.sequenceString = "최신순"
            let query = db.collection("전체보기").whereField("user", isEqualTo: self.userUid).order(by: "date", descending: true)
            getRecipeData(query: query)
        }
        
    }//UserDefaluts
    
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
                    
                    guard let titleData = data["Title"] as? String else{return}
                    guard let chefNameData = data["userNickName"] as? String else{return}
                    guard let heartPeopleData = data["heartPeople"] as? [String] else{return}
                    guard let levelData = data["segment"] as? String else{return}
                    guard let timeData = data["time"] as? String else{return}
                    guard let categoryData = data["tema"] as? String else{return}
                    guard let urlData = data["url"] as? [String] else{return}
                    guard let dateData = data["date"] as? String else{return}
                    
                    let findData = RecipeDataModel(title: titleData, chefName: chefNameData, heartPeople: heartPeopleData, level: levelData, time: timeData, date: dateData, url: urlData[0], category: categoryData, documentID: doc.documentID)
                    
                    self.recipeDataArray.append(findData)
                }
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    self.otherRecipeCollectionView.reloadData()
                    UIView.transition(with: self.otherRecipeCollectionView, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
                }
            }
        }
    }
    
    private func sequencePressed(sequence : String) {
        switch sequence {
            
        case "최신순":
            let query = db.collection("전체보기").whereField("user", isEqualTo: userUid).order(by: "date", descending: true)
            self.sequenceString = sequence
            getRecipeData(query: query)
            UserDefaults.standard.set(sequence, forKey: "sequence")
            
        case "과거순":
            let query = db.collection("전체보기").whereField("user", isEqualTo: userUid).order(by: "date", descending: false)
            self.sequenceString = sequence
            getRecipeData(query: query)
            UserDefaults.standard.set(sequence, forKey: "sequence")
            
        default:
            let query = db.collection("전체보기").whereField("user", isEqualTo: userUid).order(by: "heartPeople", descending: true)
            self.sequenceString = sequence
            getRecipeData(query: query)
            UserDefaults.standard.set(sequence, forKey: "sequence")
        }
    }
}

//MARK: - Extension
extension OtherUserProfileViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyRecipeCollectionViewCell.identifier, for: indexPath) as! MyRecipeCollectionViewCell
        
        let url = recipeDataArray[indexPath.row].url //이미지 url이 저장되어 있는 배열에서 하나씩 가져오기.
        cell.foodImageView.setImage(with: url, width: 150, height: 150)
        
        cell.foodNameLable.text = recipeDataArray[indexPath.row].title
        cell.heartCountLabel.text = "\(recipeDataArray[indexPath.row].heartPeople.count)"
        cell.categoryLabel.text = recipeDataArray[indexPath.row].category
        cell.dateLabel.text = recipeDataArray[indexPath.row].date
        
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
            headerView.categoryLabel.text = "\(nickName)님 레시피"
            headerView.subTitleLabel.text = "\(nickName)님의 레시피를 \(sequenceString)서로 보여줍니다."
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

extension OtherUserProfileViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension OtherUserProfileViewController : MyRecipeHeaderViewDelegate {
    func changeSequence(title: String) {
        self.sequencePressed(sequence: title)
    }
}

