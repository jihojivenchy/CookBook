//
//  ShowRecipeViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/01.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

final class ShowRecipeViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    private var lastSnapshotDocument : QueryDocumentSnapshot? //스크롤이 다되면 다음 데이터 가져오기
    private var collection : Query?                           //분기를 통해 쿼리조건을 설정할 변수
    private var fetchingData : Bool = true      //스크롤이 맨 하단점에 갔을 때 딱 한번만 불리도록 조정하는 변수
    private var lastDataState : Bool = false    //마지막 데이터까지 다 가져왔는데 계속 시도하려고 하는 것을 막기위해서
    
    private var recipeDataArray : [RecipeDataModel] = []
    private var blockUserArray : [String] = []
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    
    private let recipeTableView = UITableView(frame: .zero, style: .grouped)
    final let hiddenHeartImage = UIImageView() //더블 탭 인식. 좋아요 달린 효과
    private lazy var indicatorButton : UIButton = {
        let button = UIButton()
        button.setTitle("\(self.categoryArray[selectedIndex])", for: .normal)
        button.setTitleColor(.customNavy, for: .normal)
        button.titleLabel?.font = UIFont(name: KeyWord.CustomFont, size: 12)
        button.addTarget(self, action: #selector(goToTop(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        button.isHidden = true
        
        return button
    }()
    
    private let categoryArray : [String] = ["전체", "한식", "중식", "양식", "일식", "간식", "채식", "퓨전", "분식", "안주"]
    final var selectedIndex = Int() //홈에서 선택한 카테고리 조건. ex) 한식버튼 = 1번인덱스
    final var nickName = String()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomLoadingView.shared.startLoading(alpha: 0.5)
        setQuery(category: "\(self.categoryArray[selectedIndex])")
        getBlockedUserData()
        getRecipeData()
        
        naviBarAppearance()
        addSubViews()
        
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        recipeTableView.register(ShowRecipeTableViewCell.self, forCellReuseIdentifier: ShowRecipeTableViewCell.identifier)
        recipeTableView.rowHeight = 170
        recipeTableView.separatorStyle = .none
        addSwipeGesture()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func addSubViews() {
        
        view.backgroundColor = .customGray
        
        view.addSubview(recipeTableView)
        recipeTableView.backgroundColor = .clear
        recipeTableView.showsVerticalScrollIndicator = false
        recipeTableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        recipeTableView.addSubview(indicatorButton)
        
        recipeTableView.addSubview(hiddenHeartImage)
        hiddenHeartImage.isHidden = true
        hiddenHeartImage.backgroundColor = .clear
        hiddenHeartImage.image = UIImage(systemName: "suit.heart.fill")
        hiddenHeartImage.tintColor = .customSignature
        hiddenHeartImage.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.width.height.equalTo(50)
        }
        
    }
 
    private func addSwipeGesture() {
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        leftSwipeGesture.direction = .left

        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        rightSwipeGesture.direction = .right

        
        recipeTableView.addGestureRecognizer(leftSwipeGesture)
        recipeTableView.addGestureRecognizer(rightSwipeGesture)

        
    }
    
    @objc func handleLeftSwipe(gesture: UISwipeGestureRecognizer) {
        if selectedIndex == 9 { //더 이상 오른쪽으로 갈 곳이 없을 때 맨 처음으로 스크롤
            selectedIndex = 0
            
        }else{
            selectedIndex = selectedIndex + 1
        }
        
        changedIndex(index: selectedIndex)
    }

    @objc func handleRightSwipe(gesture: UISwipeGestureRecognizer) {
        if selectedIndex == 0 { //더 이상 왼쪽으로 갈 곳이 없을 때 맨 마지막으로 스크롤
            selectedIndex = 9
            
        }else{
            selectedIndex = selectedIndex - 1
        }
        
        changedIndex(index: selectedIndex)
    }
    
    private func changedIndex(index : Int) {
        self.selectedIndex = index
        self.indicatorButton.setTitle("\(self.categoryArray[index])", for: .normal)
        self.setQuery(category: "\(self.categoryArray[index])")
        self.lastDataState = false //카테고리가 바뀌면 상태 변환
        self.getRecipeData()
    } //category cell을 선택했을 때
    
    private func heartShowAnimation() { //더블 탭해서 좋아요 눌렀을 때 애니메이션
        self.hiddenHeartImage.isHidden = false
        
        UIView.animate(withDuration: 1, delay: 1, animations: {
            self.hiddenHeartImage.alpha = 0
            
        }, completion: { _ in
            self.hiddenHeartImage.isHidden = true
            self.hiddenHeartImage.alpha = 1
        })
    }
    
//MARK: - ButtonMethod
    @objc private func goToTop(_ sender : UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        self.recipeTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
//MARK: - DataMethod
    private func setQuery(category : String) {
        if category == "전체" {
            collection = db.collection("전체보기")
        }else{
            collection = db.collection("전체보기").whereField("tema", isEqualTo: category)
        }
    } //카테고리에 맞게 쿼리조건 설정
}
//MARK: - Extension
extension ShowRecipeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        DispatchQueue.main.async {
            self.indicatorButton.frame = CGRect(x: self.view.frame.width - 60, y: scrollView.contentOffset.y + 60, width: 40, height: 30)
            
            if scrollView.contentOffset.y > 270 {
                self.indicatorButton.isHidden = false
            } else {
                self.indicatorButton.isHidden = true
            }
            
            //getnextdata
            let maximumOffset = scrollView.contentSize.height - scrollView.bounds.height
            
            if scrollView.contentOffset.y >= maximumOffset {
                if self.fetchingData{
                    if scrollView.contentOffset.y != 0.0{
                        self.fetchingData = false
                        self.getNextRecipeData()
                    }
                }
            }
        }
    }
}

extension ShowRecipeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipeDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowRecipeTableViewCell.identifier, for: indexPath) as! ShowRecipeTableViewCell
        
        let url = recipeDataArray[indexPath.row].url //이미지 url이 저장되어 있는 배열에서 하나씩 가져오기.
        cell.foodImageView.setImage(with: url, width: 150, height: 150)
        
        cell.foodNameLable.text = recipeDataArray[indexPath.row].title
        cell.chefNameLabel.text = recipeDataArray[indexPath.row].chefName
        cell.heartCountLabel.text = "\(recipeDataArray[indexPath.row].heartPeople.count)"
        cell.foodLevelLabel.text = recipeDataArray[indexPath.row].level
        cell.timeLabel.text = recipeDataArray[indexPath.row].time
        cell.indexRow = indexPath.row
        cell.tapDelegate = self
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    //headerview
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let recipeHeaderView = ShowRecipeHeaderView()
        
        recipeHeaderView.selectedIndex = self.selectedIndex
        recipeHeaderView.categoryLabel.text = self.categoryArray[selectedIndex]
        recipeHeaderView.subTitleLabel.text = "\(self.categoryArray[selectedIndex]) 카테고리에 올라온 레시피들을 보여줍니다."
        recipeHeaderView.delegate = self
        
        return recipeHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 260
    }
    
    //cell이 더 이상 보이지 않을 때, 이미지를 다운로드 할 필요가 없기 때문에 cancel 시켜놓기. (메모리 절약)
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowRecipeTableViewCell.identifier, for: indexPath) as! ShowRecipeTableViewCell
        cell.foodImageView.kf.cancelDownloadTask()
    }
    
}

extension ShowRecipeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//카테고리 선택 처리
extension ShowRecipeViewController : CategoryCellClikedDelegate {
    func cellClicked(index: Int) {
        changedIndex(index: index)
    }
}

//cell 좋아요 처리
extension ShowRecipeViewController : RecipeCellDoublTabDelegate {
    func doubleTab(index: Int) {
        if Auth.auth().currentUser != nil { //로그인 유저일 때
            
            if self.recipeDataArray[index].heartPeople.contains(self.nickName){ //이미 좋아요를 눌렀다면
                let filter = recipeDataArray[index].heartPeople.filter { $0 != self.nickName }
                recipeDataArray[index].heartPeople = filter
                self.recipeTableView.reloadData()
                updateHeartPeopleData(index: index)
                ToastMessage.shared.showToast(message: " \(recipeDataArray[index].title)에 좋아요를 취소했습니다. ", durationTime: 1.5, delayTime: 1.5, width: 250, view: self.view)
            }else{
                self.recipeDataArray[index].heartPeople.append(self.nickName)
                self.recipeTableView.reloadData()
                updateHeartPeopleData(index: index)
                ToastMessage.shared.showToast(message: " \(recipeDataArray[index].title)에 좋아요를 눌렀습니다. ", durationTime: 1.5, delayTime: 1.5, width: 250, view: self.view)
            }
            
        }else{
            CustomAlert.show(title: "로그인", subMessage: "로그인이 필요한 서비스입니다.")
        }
    }
    
    private func updateHeartPeopleData(index : Int) {
        let path = db.collection("전체보기").document(recipeDataArray[index].documentID)
        path.updateData(["heartPeople" : self.recipeDataArray[index].heartPeople])
        
    }
}

//Data가져오기
extension ShowRecipeViewController {
    private func getBlockedUserData() {
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("\(user.uid).block").addSnapshotListener { querySnapshot, error in
            if let e = error{
                print("Error 차단한 유저 데이터 가져오기 실패 : \(e)")
            }else{
                guard let snapShotDocuments = querySnapshot?.documents else{return}
                
                for doc in snapShotDocuments{
                    let data = doc.data()
                    
                    if let userUid = data["user"] as? String{
                        self.blockUserArray.append(userUid)
                    }
                }
            }
        }
    } //차단한 유저 데이터 가져오기.
    
    private func getRecipeData() {
        
        collection?.order(by: "date", descending: true).limit(to: 6).getDocuments { querySnapshot, error in
            if let e = error {
                print("Error find data : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                self.recipeDataArray = []
                guard let snapshotDocuments = querySnapshot?.documents else{return} //도큐먼트들에 접근
                
                if let lastSnapshot = snapshotDocuments.last { //마지막 도큐먼트 기억했다가, 무한 스크롤링에 사용
                    self.lastSnapshotDocument = lastSnapshot
                }else {
                    print("데이터없음")
                }
                
                for doc in snapshotDocuments{
                    let data = doc.data()   //도큐먼트 안에 데이터에 접근
                    
                    guard let titleData = data["Title"] as? String else{return}
                    guard let chefNameData = data["userNickName"] as? String else{return}
                    guard let heartPeopleData = data["heartPeople"] as? [String] else{return}
                    guard let levelData = data["segment"] as? String else{return}
                    guard let timeData = data["time"] as? String else{return}
                    guard let urlData = data["url"] as? [String] else{return}
                    guard let userUidData = data["user"] as? String else{return} //유저 차단용
                    
                    let findData = RecipeDataModel(title: titleData, chefName: chefNameData, heartPeople: heartPeopleData, level: levelData, time: timeData, url: urlData[0], documentID: doc.documentID)
                    
                    if self.blockUserArray.contains(userUidData){ //가져온 데이터가 차단한 유저라면 추가하지 않음.
                    }else{
                        self.recipeDataArray.append(findData)
                        
                    }
                }
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    self.recipeTableView.reloadData()
                    UIView.transition(with: self.recipeTableView, duration: 0.2, options: .transitionCrossDissolve, animations: nil)
                }
            }
        }
    }
    
    private func getNextRecipeData(){
        //마지막 데이터인지 확인 계속 시도하는 것을 막기위함.
        if lastDataState == false {
            
            guard let lastSnapshotDocument = lastSnapshotDocument else{return}
            CustomLoadingView.shared.startLoading(alpha: 0)
            
            collection?.order(by: "date", descending: true).limit(to: 6).start(afterDocument: lastSnapshotDocument).getDocuments { querySnapshot, error in
                if let e = error {
                    print("Error find data : \(e)")
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                    }
                }else{
                    guard let snapshotDocuments = querySnapshot?.documents else{return} //도큐먼트들에 접근
                    
                    if let lastSnapshot = snapshotDocuments.last { //마지막 도큐먼트 기억했다가, 무한 스크롤링에 사용
                        self.lastSnapshotDocument = lastSnapshot
                    }else {
                        CustomAlert.show(title: "끝!", subMessage: "마지막 레시피입니다.")
                        self.lastDataState = true
                    }
                    
                    for doc in snapshotDocuments{
                        let data = doc.data()   //도큐먼트 안에 데이터에 접근
                        
                        guard let titleData = data["Title"] as? String else{return}
                        guard let chefNameData = data["userNickName"] as? String else{return}
                        guard let heartPeopleData = data["heartPeople"] as? [String] else{return}
                        guard let levelData = data["segment"] as? String else{return}
                        guard let timeData = data["time"] as? String else{return}
                        guard let urlData = data["url"] as? [String] else{return}
                        guard let userUidData = data["user"] as? String else{return} //유저 차단용
                        
                        let findData = RecipeDataModel(title: titleData, chefName: chefNameData, heartPeople: heartPeopleData, level: levelData, time: timeData, url: urlData[0], documentID: doc.documentID)
                        
                        if self.blockUserArray.contains(userUidData){ //가져온 데이터가 차단한 유저라면 추가하지 않음.
                        }else{
                            self.recipeDataArray.append(findData)
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                        self.recipeTableView.reloadData()
                        self.fetchingData = true
                    }
                }
            }
        }else{
            fetchingData = true
        }
    }
}


