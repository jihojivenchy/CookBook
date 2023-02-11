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

final class RecipeViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    final var recipeData : RecipeDataModel = .init(title: "", chefName: "", heartPeople: [], level: "", time: "", date: "", url: "", category: "", documentID: ""){
        didSet{
            self.getRecipeData()
        }
    }  //기본적으로 가지고 있던 정보들.
    
    private var detailRecipeData = DetailRecipeModel(urlArray: [], contentsArray: [], ingredients: "", userNickName: "", userUID: "", comments: 0) //나머지 가지고 올 정보들.
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private lazy var dismissButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(dismissButtonPressed(_:)))
        sb.tintColor = .customSignature
        
        return sb
    }()
    
    private lazy var menuButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .done, target: self, action: #selector(menuButtonPressed(_:)))
        
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
        self.navigationItem.rightBarButtonItem = menuButton
    }
    
    private func addSubViews() {
        view.backgroundColor = .customGray
        
        view.addSubview(recipeTableView)
        recipeTableView.backgroundColor = .clear
        recipeTableView.showsVerticalScrollIndicator = false
        recipeTableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    
//MARK: - ButtonMethod
    @objc private func dismissButtonPressed(_ sender : UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func menuButtonPressed(_ sender : UIBarButtonItem) {
        
    }
    
//MARK: - DataMethod
    private func getRecipeData() {
        CustomLoadingView.shared.startLoading(alpha: 0.5)
        
        db.collection("전체보기").document(recipeData.documentID).getDocument { dos, error in
            if let e = error {
                print("Error 레시피 데이터 가져오기 실패 : \(e)")
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                if let data = dos?.data() {
                    
                    guard var urlData = data["url"] as? [String] else{return}
                    guard let contentsData = data["contents"] as? [String] else{return}
                    guard let ingredientData = data["ingredients"] as? String else{return}
                    guard let userNickNameData = data["userNickName"] as? String else{return}
                    guard let userUIDData = data["user"] as? String else{return}
                    guard let commentsData = data["comments"] as? Int else{return}
                    
                    urlData.removeFirst()
                    urlData.append(self.recipeData.url)
                    
                    self.detailRecipeData = DetailRecipeModel(urlArray: urlData, contentsArray: contentsData, ingredients: ingredientData, userNickName: userNickNameData, userUID: userUIDData, comments: commentsData)
                }
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    self.recipeTableView.reloadData()
                }
            }
        }
    }
}

//MARK: - Extension
extension RecipeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailRecipeData.contentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailRecipeTableViewCell.identifier, for: indexPath) as! DetailRecipeTableViewCell
        
        cell.contentView.isUserInteractionEnabled = false
        
        let content = detailRecipeData.contentsArray[indexPath.row]
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
        recipeHeaderView.name = detailRecipeData.userNickName
        recipeHeaderView.commentsCount = detailRecipeData.comments
        recipeHeaderView.recipeData = recipeData
        recipeHeaderView.ingredientsTextView.text = detailRecipeData.ingredients
        
        return recipeHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 820
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
        let vc = OtherUserProfileViewController()
        vc.nickName = detailRecipeData.userNickName
        vc.userUid = detailRecipeData.userUID
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func commentsButtonPressed() {
        let vc = OtherUserProfileViewController()
        vc.nickName = detailRecipeData.userNickName
        vc.userUid = detailRecipeData.userUID
        
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
