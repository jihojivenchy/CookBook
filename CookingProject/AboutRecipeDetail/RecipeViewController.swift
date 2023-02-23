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
    
    final var recipeDocumentID = String()
    final var goToComment : Bool = false
    
    private var detailRecipeData = DetailRecipeModel(foodName: "", foodLevel: "", foodTime: "", foodCategory: "", ingredients: "", contents: [], userName: "", userUID: "", heartPeople: [], imageFile: [], urlArray: [], commentCount: 0) //레시피정보
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let recipeTableView = UITableView(frame: .zero, style: .grouped)

//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipeData()
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
    
    //알림 뷰에서 왔을 때는 바로 댓글 뷰로 이동하도록.
    private func goToCommentView() {
        if goToComment {
            goToComment = false
            let vc = CommentsViewController()
            vc.recipeDocumentID = self.recipeDocumentID
            vc.recipeUserUID = detailRecipeData.userUID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//MARK: - ButtonMethod
    
//MARK: - DataMethod
    private func getRecipeData() {
        CustomLoadingView.shared.startLoading()
        
        db.collection("전체보기").document(recipeDocumentID).addSnapshotListener{ dos, error in
            if let e = error {
                print("Error 레시피 데이터 가져오기 실패 : \(e)")
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                if let data = dos?.data() {
                    
                    guard let foodNameData = data[DataKeyWord.foodName] as? String else{return}
                    guard let foodLevelData = data[DataKeyWord.foodLevel] as? String else{return}
                    guard let foodTimeData = data[DataKeyWord.foodTime] as? String else{return}
                    guard let foodCategoryData = data[DataKeyWord.foodCategory] as? String else{return}
                    guard let ingredientData = data[DataKeyWord.ingredients] as? String else{return}
                    guard let contentsData = data[DataKeyWord.contents] as? [String] else{return}
                    guard let userNameData = data[DataKeyWord.userName] as? String else{return}
                    guard let userUIDData = data[DataKeyWord.userUID] as? String else{return}
                    guard let heartData = data[DataKeyWord.heartPeople] as? [String] else{return}
                    guard let imageFileData = data[DataKeyWord.imageFile] as? [String] else{return}
                    guard var urlData = data[DataKeyWord.url] as? [String] else{return}
                    guard let commentCountData = data[DataKeyWord.commentCount] as? Int else{return}
                    
                    let url = urlData[0]
                    urlData.removeFirst()
                    urlData.append(url)
                    
                    self.detailRecipeData = DetailRecipeModel(foodName: foodNameData, foodLevel: foodLevelData, foodTime: foodTimeData, foodCategory: foodCategoryData, ingredients: ingredientData, contents: contentsData, userName: userNameData, userUID: userUIDData, heartPeople: heartData, imageFile: imageFileData, urlArray: urlData, commentCount: commentCountData)
                }
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    self.checkUserState() //현재 레시피와 내 정보를 비교.
                    self.recipeTableView.reloadData()
                    self.goToCommentView()
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
        
        let urlCount = detailRecipeData.urlArray.count
        
        if urlCount != 0 { //url 데이터가 모두 들어오고 나서 헤더뷰에 데이터가 들어가도록
            recipeHeaderView.recipeHeaderData = DetailRecipeHeaderModel(foodName: detailRecipeData.foodName, foodLevel: detailRecipeData.foodLevel, foodTime: detailRecipeData.foodTime, foodCategory: detailRecipeData.foodCategory, heartPeopleCount: detailRecipeData.heartPeople.count, commentCount: detailRecipeData.commentCount, ingredients: detailRecipeData.ingredients, url: detailRecipeData.urlArray[urlCount - 1], userName: detailRecipeData.userName)
        }
        
        
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
        vc.documentID = self.recipeDocumentID
        vc.heartUserUidArray = self.detailRecipeData.heartPeople
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userButtonPressed() {
        let vc = MyRecipeViewController()
        vc.userName = detailRecipeData.userName
        vc.userUid = detailRecipeData.userUID
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func commentsButtonPressed() {
        let vc = CommentsViewController()
        vc.recipeDocumentID = self.recipeDocumentID
        vc.recipeUserUID = detailRecipeData.userUID
        
        self.navigationController?.pushViewController(vc, animated: true)
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
        let url = urlArray[urlArray.count - 1]
        urlArray.removeLast()
        urlArray.insert(url, at: 0)
        
        vc.modifyRecipeData = ModifyRecipeDataModel(foodName: detailRecipeData.foodName,
                                                    foodCategory: detailRecipeData.foodCategory,
                                                    foodLevel: detailRecipeData.foodLevel,
                                                    foodTime: detailRecipeData.foodTime,
                                                    contents: detailRecipeData.contents,
                                                    ingredients: detailRecipeData.ingredients,
                                                    urlArray: urlArray, documentID: self.recipeDocumentID)
        
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
        CustomLoadingView.shared.startLoading()
        
        self.deleteCommentsData(documentID: self.recipeDocumentID) //레시피 댓글데이터 삭제
        self.db.collection("전체보기").document(self.recipeDocumentID).delete() //레시피 데이터 삭제
        self.deleteImageData(files: detailRecipeData.imageFile) //레시피 이미지들 삭제
        
        
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


