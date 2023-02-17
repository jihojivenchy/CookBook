//
//  RecipeViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/09.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import SCLAlertView

final class RecipeViewController: UIViewController {
//MARK: - Properties
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    final var recipeData : RecipeDataModel = .init(foodName: "", userName: "", heartPeople: [], foodLevel: "", foodTime: "", writedDate: "", url: "", foodCategory: "", documentID: ""){
        didSet{
            self.getRecipeData()
        }
    }  //기본적으로 가지고 있던 정보들.
    
    private var detailRecipeData = DetailRecipeModel(imageFile: [], urlArray: [], contents: [], ingredients: "", userUID: "", commentCount: 0) //나머지 가지고 올 정보들.
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let recipeTableView = UITableView(frame: .zero, style: .grouped)
    
    final var myName = String()

//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        addSubViews()
        
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        recipeTableView.tableHeaderView = DetailRecipeHeaderView()
        recipeTableView.register(DetailRecipeTableViewCell.self, forCellReuseIdentifier: DetailRecipeTableViewCell.identifier)
        recipeTableView.rowHeight = 170
        recipeTableView.separatorStyle = .none
        recipeTableView.contentInset = .zero
        recipeTableView.contentInsetAdjustmentBehavior = .never
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .customNavy
        
        self.navigationItem.backBarButtonItem = backButton
    }
    
    private func addSubViews() {
        view.backgroundColor = .customWhite
        
        view.addSubview(recipeTableView)
        recipeTableView.backgroundColor = .clear
        recipeTableView.showsVerticalScrollIndicator = false
        recipeTableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    
//MARK: - ButtonMethod
    
//MARK: - DataMethod
    private func getRecipeData() {
        CustomLoadingView.shared.startLoading(alpha: 0.5)
        
        db.collection("전체보기").document(recipeData.documentID).addSnapshotListener{ dos, error in
            if let e = error {
                print("Error 레시피 데이터 가져오기 실패 : \(e)")
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                if let data = dos?.data() {
                    
                    guard let imageFileData = data[DataKeyWord.imageFile] as? [String] else{return}
                    guard var urlData = data[DataKeyWord.url] as? [String] else{return}
                    guard let contentsData = data[DataKeyWord.contents] as? [String] else{return}
                    guard let ingredientData = data[DataKeyWord.ingredients] as? String else{return}
                    guard let userUIDData = data[DataKeyWord.userUID] as? String else{return}
                    guard let commentCountData = data[DataKeyWord.commentCount] as? Int else{return}
                    
                    urlData.removeFirst()
                    urlData.append(self.recipeData.url)
                    
                    self.detailRecipeData = DetailRecipeModel(imageFile: imageFileData, urlArray: urlData, contents: contentsData, ingredients: ingredientData, userUID: userUIDData, commentCount: commentCountData)
                    
                    
                }
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    self.checkUserState() //현재 레시피와 내 정보를 비교.
                    self.recipeTableView.reloadData()
                }
            }
        }
    }
}

//MARK: - Extension
extension RecipeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailRecipeData.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailRecipeTableViewCell.identifier, for: indexPath) as! DetailRecipeTableViewCell
        
        cell.contentView.isUserInteractionEnabled = false
        
        let content = detailRecipeData.contents[indexPath.row]
        cell.recipeTextView.text = content
        
        
        if detailRecipeData.urlArray.count - 1 >= indexPath.row {
            let url = detailRecipeData.urlArray[indexPath.row]
            cell.foodImageView.setImage(with: url, width: 130, height: 150)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    //cell이 더 이상 보이지 않을 때, 이미지를 다운로드 할 필요가 없기 때문에 cancel 시켜놓기. (메모리 절약)
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailRecipeTableViewCell.identifier, for: indexPath) as! DetailRecipeTableViewCell
        cell.foodImageView.kf.cancelDownloadTask()
    }
    
    
    //headerview
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let recipeHeaderView = DetailRecipeHeaderView()
        
        recipeHeaderView.delegate = self
        recipeHeaderView.name = recipeData.userName
        recipeHeaderView.commentsCount = detailRecipeData.commentCount
        recipeHeaderView.recipeData = recipeData
        recipeHeaderView.ingredientsTextView.text = detailRecipeData.ingredients
        
        return recipeHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 820
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
}

extension RecipeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//헤더뷰의 버튼들 delegate
extension RecipeViewController : RecipeHeaderDelegate {
    func heartButtonPressed() {
        let vc = HeartClickedUsersViewController()
        vc.delegate = self
        vc.myName = self.myName
        vc.documentID = self.recipeData.documentID
        vc.heartUserUidArray = self.recipeData.heartPeople
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userButtonPressed() {
        let vc = MyRecipeViewController()
        vc.myName = self.myName
        vc.userName = recipeData.userName
        vc.userUid = detailRecipeData.userUID
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func commentsButtonPressed() {
        let vc = CommentsViewController()
        vc.recipeDocumentID = recipeData.documentID
        vc.myName = self.myName
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//heartclickedview에서 전달한 하트 갯수 변경사항.
extension RecipeViewController : HeartButtonClickedDelegate {
    func clickedButton(heartUserData: [String]) {
        recipeData.heartPeople = heartUserData
        self.recipeTableView.reloadData()
    }
}

//데이터 삭제와 수정에 대한 alert
extension RecipeViewController {
    private func checkUserState() {
        if let user = Auth.auth().currentUser{ //먼저 로그인 체크.
            
            if detailRecipeData.userUID == user.uid { //현재 페이지의 유저정보와 내 정보를 비교.
                let deleteAction = UIAction(title: "삭제하기",image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in self.deleteRecipeAlert()})
                
                let editAction = UIAction(title: "수정하기",image: UIImage(systemName: "pencil"), handler: { _ in self.goToModifyRecipe()})
                
                let menu = UIMenu(title: "", identifier: nil, options: .displayInline, children: [editAction, deleteAction])
                
                let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), primaryAction: .none, menu: menu)
                self.navigationItem.rightBarButtonItem = menuButton
                
            }else{
                self.navigationItem.rightBarButtonItem = .none
            }
            
        }else{
            self.navigationItem.rightBarButtonItem = .none
        }
    }//현재 페이지의 정보가 내정보인지 다른 유저의 정보인지 체크
    
    //레시피 수정
    private func goToModifyRecipe() {
        let vc = MFCategoryViewController()
        
        //마지막으로 변경해두었던 대표이미지를 다시 첫번째로 돌리고 url데이터 넘겨줌.
        var urlArray = detailRecipeData.urlArray
        urlArray.removeLast()
        urlArray.insert(recipeData.url, at: 0)
        
        vc.modifyRecipeData = ModifyRecipeDataModel(foodName: recipeData.foodName,
                                                    foodCategory: recipeData.foodCategory,
                                                    foodLevel: recipeData.foodLevel, foodTime: recipeData.foodTime,
                                                    contents: detailRecipeData.contents,
                                                    ingredients: detailRecipeData.ingredients,
                                                    urlArray: urlArray, documentID: recipeData.documentID)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//데이터 삭제 관련.
extension RecipeViewController {
    //레시피 데이터 삭제할지 한번 더 물어보기.
    private func deleteRecipeAlert() {
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
    
    //레시피 데이터삭제
    private func deleteRecipeData() {
        CustomLoadingView.shared.startLoading(alpha: 0.5)
        
        let documentID = self.recipeData.documentID
        
        db.collection("전체보기").document(documentID).getDocument { qs, error in
            if let e = error {
                print("Error 삭제 전 레시피 데이터 가져오기 실패 : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                if let data = qs?.data() {
                    
                    guard let imageFileNameData = data[DataKeyWord.imageFile] as? [String] else{return}
                    
                    self.deleteImageData(files: imageFileNameData)
                    self.deleteCommentsData(documentID: documentID)
                    self.db.collection("전체보기").document(documentID).delete()
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
                        self.navigationController?.popViewController(animated: true)
                        print("이미지 삭제완료.")
                    }
                }
            }
        }
    }
    
    //댓글 데이터 삭제.
    private func deleteCommentsData(documentID : String) {
        let commentRef = db.collection("전체보기").document(documentID).collection("댓글")
        
        commentRef.getDocuments { qs, error in
            if let e = error{
                print("Error find message data : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                guard let snapShotDocuments = qs?.documents else{return}
                
                for doc in snapShotDocuments {
                    
                    commentRef.document(doc.documentID).delete()
                    //대댓글 데이터삭제
                    self.deleteChildCommentsData(documentID: documentID, commentDocumentID: doc.documentID)
                }
            }
        }
    }
    
    //대댓글 데이터 삭제
    private func deleteChildCommentsData(documentID : String, commentDocumentID : String) {
        let childRef = db.collection("전체보기").document(documentID).collection("댓글").document(commentDocumentID).collection("답글")
        
        childRef.getDocuments { qs, error in
            if let e = error{
                print("Error 대댓글 데이터 가져오기 실패 : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                guard let snapShotDocuments = qs?.documents else{return}
                
                for doc in snapShotDocuments {
                    
                    childRef.document(doc.documentID).delete()
                }
            }
        }
    }
}


