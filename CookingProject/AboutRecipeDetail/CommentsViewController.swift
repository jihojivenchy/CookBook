//
//  CommentsTestViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/12.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class CommentsViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    
    private var blockUserArray : [String] = [] //차단유저
    private var commentsDataArray : [CommentsDataModel] = [] //댓글
    
    final var recipeDocumentID = String() //현재 레시피 도큐먼트아이디
    final var recipeUserUID = String() //현재 레시피의 주인.
    
    private var blockCommentCount = Int() //블락된 댓글이 몇개인지 센다. 이유는 차단유저리스트가 있는 유저가 댓글을 남길 시에 댓글 카운트를 갱신해주어야하는데 필요
    private var commentIndexSection = Int()     //대댓글을 어떤 댓글에 남길 것인지 섹션번호기억.
    private var childMode : Bool = false //대댓글을 남기는 건지, 그냥 댓글을 남기는 건지 모드를 나눔.
    private let childCommentLabel = UILabel() //대댓글 남길 때 표시해주기위함.
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let commentsTableView = UITableView()
    
    private lazy var commentsTextView : UITextView = {
        let tv = UITextView()
        tv.returnKeyType = .next
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 10
        tv.font = .systemFont(ofSize: 18)
        tv.textColor = .black
        tv.tintColor = .black
        tv.backgroundColor = .white
        tv.delegate = self
        
        return tv
    }()
    
    private lazy var sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("전송", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: FontKeyWord.CustomFont, size: 17)
        button.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .customSignature
        
        return button
    }() //heart누른 유저들 보여주는 뷰로 이동하는 버튼
    
    private lazy var refresh : UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = .customSignature
        rf.addTarget(self, action: #selector(reloadAction(_:)), for: .valueChanged)
        
        return rf
    }()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomLoadingView.shared.startLoading()
        
        getBlockedUserData()
        getCommentsData()
        addSubViews()
        naviBarAppearance()
        
        commentsTableView.refreshControl = refresh
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.identifier)
        commentsTableView.register(ChildCommentTableViewCell.self, forCellReuseIdentifier: ChildCommentTableViewCell.identifier)
        commentsTableView.estimatedRowHeight = 120
        commentsTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotifications()
    }
    
    //MARK: - ViewMethod
    private func naviBarAppearance() {
        navigationItem.title = "댓글"
        navigationItem.backBarButtonItem = backButton
    }
    
    private func addSubViews() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))//개체들이 모두 스크롤뷰 위에 존재하기 때문에 스크롤뷰 특성 상 touchBegan함수가 실행되지 않는다. 따라서 스크롤뷰에 대한 핸들러 캐치를 등록해주어야 한다.
        view.backgroundColor = .customWhite
        
        view.addSubview(commentsTableView)
        commentsTableView.backgroundColor = .clear
        commentsTableView.showsVerticalScrollIndicator = false
        commentsTableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
        }
        
        view.addSubview(commentsTextView)
        commentsTextView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(70)
            make.height.equalTo(40)
        }
        
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.left.equalTo(commentsTextView.snp_rightMargin).offset(15)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(childCommentLabel)
        childCommentLabel.alpha = 0
        childCommentLabel.textColor = .white
        childCommentLabel.textAlignment = .center
        childCommentLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 13)
        childCommentLabel.backgroundColor = .gray
        childCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // todo...
        }
    }//스크롤뷰 터치 시에 endEditing 발생
    
    @objc private func reloadAction(_ sender : UIRefreshControl) {
        commentsTableView.reloadData()
        refresh.endRefreshing()
    }
    
    private func showChildCommentLabel(text : String) {
        childCommentLabel.text = text
        self.childCommentLabel.isHidden = false
        UIView.transition(with: childCommentLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.childCommentLabel.alpha = 1
        })
    }
    
    private func hideChildCommentLabel() {
        UIView.transition(with: childCommentLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.childCommentLabel.alpha = 0
        }, completion: { _ in
            self.childCommentLabel.isHidden = true
        })
    }
    
//MARK: - ButtonMethod
    @objc private func sendButtonPressed(_ seder : UIButton) {
        //textview 제자리
        commentsTextView.endEditing(true)
        commentsTextView.snp.updateConstraints { (make) in
            make.height.equalTo(40)
        }
        
        guard let comment = commentsTextView.text else{return}
        
        if let user = Auth.auth().currentUser { //login check
            //댓글을 작성했는지 파악
            if comment != "" {
                
                //대댓글을 남긴것인지, 댓글을 남긴것인지 체크.
                if childMode {
                    self.childMode = false
                    let commentDocumenID = commentsDataArray[self.commentIndexSection].commentDocumentID //어떤 댓글에 대댓글을 달았는지 도큐먼트.
                    self.setChildComments(userUID: user.uid, comment: comment, commentDocumentID: commentDocumenID)
                    self.setCommentNotiData(userUID: user.uid, comment: comment)
                    
                }else{//댓글데이터 저장.
                    self.setCommentsData(uid: user.uid, comment: comment)
                    self.setRecipeNotiData(userUID: user.uid, comment: comment)
                }
            }

        }else{ //로그인 안됨.
            CustomAlert.show(title: "로그인", subMessage: "로그인이 필요한 서비스입니다.")
        }
        
    }
    
//MARK: - KeyBoardMethod
    private func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            commentsTableView.snp.updateConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight + 60)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.commentsTextView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
                self.sendButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            })
            
        }
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc private func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        commentsTableView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.commentsTextView.transform = .identity
            self.sendButton.transform = .identity
        })
        self.hideChildCommentLabel()
    }

    // 노티피케이션을 제거하는 메서드
    private func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

//MARK: - Extension
extension CommentsViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.contentSize
        let newHeight = max(size.height, 40)
        textView.snp.updateConstraints { (make) in
            make.height.equalTo(newHeight)
        }
    }
}

extension CommentsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.commentsDataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.commentsDataArray[section].childComments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.identifier, for: indexPath) as! CommentsTableViewCell
            
            cell.userNameLabel.text = commentsDataArray[indexPath.section].userName
            cell.commentLabel.text = commentsDataArray[indexPath.section].comment
            cell.dateLabel.text = commentsDataArray[indexPath.section].date
            cell.index = indexPath.section
            cell.delegate = self
            
            cell.contentView.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ChildCommentTableViewCell.identifier, for: indexPath) as! ChildCommentTableViewCell
    
            if commentsDataArray[indexPath.section].childComments.count >= indexPath.row {
                //section indexpath.row가 0인 cell들은 댓글로 표현, 나머지는 대댓글로 들어가야 하기 때문에 -1 해줌.
                cell.userNameLabel.text = commentsDataArray[indexPath.section].childComments[indexPath.row - 1].userName
                cell.commentLabel.text = commentsDataArray[indexPath.section].childComments[indexPath.row - 1].comment
                cell.dateLabel.text = commentsDataArray[indexPath.section].childComments[indexPath.row - 1].date
                cell.section = indexPath.section
                cell.index = indexPath.row - 1
                cell.ChildCommentDelegate = self
            }
            
            cell.contentView.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension CommentsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//댓글 데이터 관련 처리
extension CommentsViewController {
    private func getBlockedUserData() {
        guard let user = Auth.auth().currentUser else{return}
        
        db.collection("\(user.uid).block").addSnapshotListener { querySnapshot, error in
            if let e = error{
                print("Error 차단한 유저 데이터 가져오기 실패 : \(e)")
            }else{
                guard let snapShotDocuments = querySnapshot?.documents else{return}
                
                for doc in snapShotDocuments{
                    let data = doc.data()
                    
                    if let userUid = data[DataKeyWord.userUID] as? String{
                        self.blockUserArray.append(userUid)
                    }
                }
            }
        }
    } //차단한 유저 데이터 가져오기.
    
    private func getCommentsData() {
        db.collection("전체보기").document(recipeDocumentID).collection("댓글").order(by: "timeStamp", descending: false).addSnapshotListener { qs, error in
            if let e = error{
                print("Error 댓글 데이터 과거시간(내림차순) 순대로 가져오기 실패 : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                self.commentsDataArray = []
                var blockCount = 0 //인덱스에 맞게 대댓글 데이터를 가져와야하는데, 차단한 유저가 생기면 인덱스가 어긋나는 현상이 생김. 그래서 카운트를 세어주고, 블락 카운트만큼 빼준 인덱스를 넣어주어야 함
                
                guard let snapShotDocuments = qs?.documents else{return}
                
                for (index, doc) in snapShotDocuments.enumerated() {
                    let data = doc.data()
                    
                    guard let commentData = data[DataKeyWord.comment] as? String else{return}
                    guard let dateData = data[DataKeyWord.writedDate] as? String else{return}
                    guard let userUIDData = data[DataKeyWord.userUID] as? String else{return}
                    guard let userNameData = data[DataKeyWord.userName] as? String else{return}
                    
                    
                    if self.blockUserArray.contains(userUIDData){ //가져온 데이터가 차단한 유저라면 추가하지 않음.
                        blockCount += 1
                    }else{
                        let findData = CommentsDataModel(comment: commentData, childComments: [], date: dateData, userUID: userUIDData, userName: userNameData, commentDocumentID: doc.documentID)
                        self.commentsDataArray.append(findData)
                        
                        self.getChildCommentData(commentDocumentID: doc.documentID, index: index - blockCount)
                    }
                }
                DispatchQueue.main.async {
                    self.blockCommentCount = blockCount
                    CustomLoadingView.shared.stopLoading()
                    self.commentsTableView.reloadData()
                }
            }
            
        }
    }//댓글데이터가져오기.
    
    private func getChildCommentData(commentDocumentID : String, index : Int) {
        let childRef = db.collection("전체보기").document(recipeDocumentID).collection("댓글").document(commentDocumentID).collection("답글").order(by: "timeStamp", descending: false)
        
        childRef.addSnapshotListener { qs, error in
            if let e = error {
                print("Error 대댓글 데이터 가져오기 실패 : \(e.localizedDescription)")
            }else{
                guard let snapShotDocuments = qs?.documents else{return}
                if self.commentsDataArray.count != 0 { //추가된 데이터들이 없는데 여기서 확인하면 해당 인덱스가 없는 오류가 발생하기 때문
                    self.commentsDataArray[index].childComments = [] //대댓글 데이터 초기화
                }
                
                for doc in snapShotDocuments {
                    let data = doc.data()
                    
                    guard let commentData = data[DataKeyWord.comment] as? String else{return}
                    guard let dateData = data[DataKeyWord.writedDate] as? String else{return}
                    guard let userUIDData = data[DataKeyWord.userUID] as? String else{return}
                    guard let userNameData = data[DataKeyWord.userName] as? String else{return}
                    
                    if self.blockUserArray.contains(userUIDData){ //가져온 데이터가 차단한 유저라면 추가하지 않음.
                    }else{
                        let findData = ChildCommentsDataModel(comment: commentData, date: dateData, userUID: userUIDData, userName: userNameData, childDocumentID: doc.documentID)
                        
                        if self.commentsDataArray.count != 0 { //추가된 데이터들이 없는데 여기서 확인하면 해당 인덱스가 없는 오류가 발생하기 때문
                            self.commentsDataArray[index].childComments.append(findData)
                        }
                        
                    }
                }
                
                DispatchQueue.main.async {
                    print("childComment end")
                    self.commentsTableView.reloadData()
                }
            }
        }
    }
    
    private func setCommentsData(uid : String, comment : String) {
        guard let myName = UserDefaults.standard.string(forKey: "myName") else{return}
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "yyyy-MM-dd HH:mm"
        let convertDate = formatDate.string(from: Date()) //date형식 원하는 형태로 format
        
        //댓글 갯수 갱신하기 위해 임의로 넣어줌.(어차피 데이터에 수정사항 생기면 데이터 가져오면서 배열 초기화)
        self.commentsDataArray.append(CommentsDataModel(comment: comment, childComments: [], date: convertDate, userUID: uid, userName: myName, commentDocumentID: ""))
        
        //댓글 데이터 저장.(핵심.)
        db.collection("전체보기").document(recipeDocumentID).collection("댓글").addDocument(data:
                                                                [DataKeyWord.comment : comment,
                                                                 DataKeyWord.writedDate : convertDate,
                                                                 DataKeyWord.userUID : uid,
                                                                 DataKeyWord.userName : myName,
                                                                 "timeStamp" : Date().timeIntervalSince1970])
        
        //댓글 갯수 갱신.
        if blockUserArray.isEmpty { //블락유저가 없을 때,
            db.collection("전체보기").document(recipeDocumentID).updateData([DataKeyWord.commentCount : self.commentsDataArray.count])
            
        }else{ //블락유저가 있을 때, 차단된 댓글 갯수 +해서 댓글 갯수 갱신.
            db.collection("전체보기").document(recipeDocumentID).updateData([DataKeyWord.commentCount : self.commentsDataArray.count + self.blockCommentCount])
        }
        
        DispatchQueue.main.async {
            self.commentsTextView.text = ""  //text 초기화
            
            if self.commentsDataArray.count > 3{
                let indexPath = IndexPath(row: 0, section: self.commentsDataArray.count - 2)
                self.commentsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }//댓글 데이터 저장
}

//댓글 안의 메뉴버튼 클릭했을 때 처리
extension CommentsViewController : CommentMenuButtonDelegate {
    //답글달기 버튼 클릭.(delegateMethod)
    func childButtonClicked(index: Int) {
        let userName = commentsDataArray[index].userName
        
        self.commentIndexSection = index
        self.childMode = true
        self.showChildCommentLabel(text: "\(userName)님에게 답글을 남기는 중..")
        
        self.commentsTextView.becomeFirstResponder()
    }
    
    
    //menuButton 클릭(delegateMethod)
    func menuButtonClicked(index: Int) {
        if let user = Auth.auth().currentUser{//login check
            
            if commentsDataArray[index].userUID == user.uid {
                self.modifyAndDeleteComment(index: index)
                
            }else{
                self.blockAndReportComment(myUID: user.uid,
                                           userUID: commentsDataArray[index].userUID,
                                           userName: commentsDataArray[index].userName)
            }
                
                
        }else{
            CustomAlert.show(title: "로그인", subMessage: "로그인이 필요한 서비스입니다.")
        }
    }
    
    //내가 작성한 댓글 수정이나 삭제
    private func modifyAndDeleteComment(index : Int){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: "수정하기", style: .default) { action in
            self.modifyComment(index: index)
        }
        modifyAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { action in
            self.deleteComment(index: index)
        }
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //댓글 수정
    private func modifyComment(index : Int){
        let vc = ModifyCommentViewController()
        vc.recipeDocumentID = self.recipeDocumentID
        vc.commentData = self.commentsDataArray[index]
        vc.commentsTextView.text = self.commentsDataArray[index].comment
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //댓글 삭제
    private func deleteComment(index : Int) {
        //해당 댓글 데이터 삭제
        let ref = db.collection("전체보기").document(recipeDocumentID).collection("댓글")
        ref.document(self.commentsDataArray[index].commentDocumentID).delete()
        
        self.commentsDataArray.remove(at: index)
        
        //해당 레시피 댓글갯수 수정.
        if blockUserArray.isEmpty { //블락유저가 없을 때,
            db.collection("전체보기").document(recipeDocumentID).updateData([DataKeyWord.commentCount : self.commentsDataArray.count])
            
        }else{ //블락유저가 있을 때, 차단된 댓글 갯수 +해서 댓글 갯수 갱신.
            db.collection("전체보기").document(recipeDocumentID).updateData([DataKeyWord.commentCount : self.commentsDataArray.count + self.blockCommentCount])
        }
    }
    
    //댓글 작성자 차단이나 신고
    private func blockAndReportComment(myUID : String, userUID : String, userName : String){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let blockAction = UIAlertAction(title: "작성자 차단하기", style: .default) { action in
            self.db.collection("\(myUID).block").addDocument(data:
                                                              [DataKeyWord.userUID : userUID,
                                                               DataKeyWord.userName: userName])
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        blockAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let reportAction = UIAlertAction(title: "작성자 신고하기", style: .default) { action in
            let vc = FeedBackViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        reportAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(blockAction)
        alert.addAction(reportAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

//대댓글 관련처리
extension CommentsViewController : ChildCommentMenuDelegate {
    //대댓글 달기.
    private func setChildComments(userUID : String, comment : String, commentDocumentID : String) {
        guard let myName = UserDefaults.standard.string(forKey: "myName") else{return}
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "yyyy-MM-dd HH:mm"
        let convertDate = formatDate.string(from: Date()) //date형식 원하는 형태로 format
        
        let childRef = db.collection("전체보기").document(recipeDocumentID).collection("댓글").document(commentDocumentID).collection("답글")
        
        childRef.addDocument(data: [DataKeyWord.comment : comment,
                                    DataKeyWord.writedDate : convertDate,                                            DataKeyWord.userUID : userUID,                                                DataKeyWord.userName : myName,
                                    "timeStamp" : Date().timeIntervalSince1970]) { error in
            if let e = error{
                print("Error 대댓글 데이터 저장 실패 : \(e.localizedDescription)")
            }else{
                DispatchQueue.main.async {
                    self.commentsTextView.text = ""  //text 초기화
                    let indexPath = IndexPath(row: 0, section: self.commentIndexSection)
                    self.commentsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    //대댓글 메뉴버튼 클릭
    func ChildCommentMenuClicked(section : Int, index : Int) {
        if let user = Auth.auth().currentUser{//login check
            
            let childCommentIndex = commentsDataArray[section].childComments[index] //어디 댓글 섹션의 몇번 대댓글 인덱스인지
            
            //해당 대댓글이 내가 작성한 것인지 판단.
            if childCommentIndex.userUID == user.uid {
                self.ModiAndDeleteChildAlert(section: section, index: index)
                
            }else{
                self.blockAndReportChildAlert(myUID: user.uid,
                                              userUID: childCommentIndex.userUID,
                                              userName: childCommentIndex.userName)
            }
             
        }else{
            CustomAlert.show(title: "로그인", subMessage: "로그인이 필요한 서비스입니다.")
        }
    }
     
    //대댓글 수정이나 삭제 alert
    private func ModiAndDeleteChildAlert(section : Int, index : Int){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: "수정하기", style: .default) { action in
            self.modifyChildComment(section: section, index: index)
        }
        modifyAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { action in
            self.deleteChildComment(section: section, index: index)
        }
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //대댓글 수정
    private func modifyChildComment(section : Int, index : Int){
        let vc = ModifyCommentViewController()
        vc.recipeDocumentID = self.recipeDocumentID
        vc.commentData = self.commentsDataArray[section]
        vc.commentsTextView.text = self.commentsDataArray[section].childComments[index].comment
        vc.childDocumentIndex = index
        vc.childMode = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //대댓글 삭제
    private func deleteChildComment(section : Int, index : Int) {
        //해당 대댓글 데이터 삭제
        let commentDocumentID = self.commentsDataArray[section].commentDocumentID
        let childDocumentID = self.commentsDataArray[section].childComments[index].childDocumentID
        
        db.collection("전체보기").document(recipeDocumentID).collection("댓글").document(commentDocumentID).collection("답글").document(childDocumentID).delete()
    }
    
    //댓글 작성자 차단이나 신고
    private func blockAndReportChildAlert(myUID : String, userUID : String, userName : String){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let blockAction = UIAlertAction(title: "작성자 차단하기", style: .default) { action in
            self.db.collection("\(myUID).block").addDocument(data:
                                                              [DataKeyWord.userUID : userUID,
                                                               DataKeyWord.userName: userName])
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        blockAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let reportAction = UIAlertAction(title: "작성자 신고하기", style: .default) { action in
            let vc = FeedBackViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        reportAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(blockAction)
        alert.addAction(reportAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}

//댓글을 달았을 때, 상대방에게 알림이 가는 처리.
extension CommentsViewController {
    //상대 레시피에 댓글을 달았을 경우.
    private func setRecipeNotiData(userUID : String, comment : String) {
        if userUID == self.recipeUserUID { //내 레시피에 내가 댓글을 달았을 때는 알림이 울릴 필요가 없다.
        }else{
            //레시피 주인에게 내가 단 댓글알림이 간다.
            guard let myName = UserDefaults.standard.string(forKey: "myName") else{return}
            
            let formatDate = DateFormatter()
            formatDate.dateFormat = "yyyy-MM-dd HH:mm"
            let convertDate = formatDate.string(from: Date()) //date형식 원하는 형태로 format
            
            db.collection("\(recipeUserUID).Noti").addDocument(data: [DataKeyWord.userUID : userUID,
                                                                      DataKeyWord.userName : myName,
                                                                      "recipeDocumentID" : self.recipeDocumentID,
                                                                      "version" : 0,
                                                                      DataKeyWord.comment : comment,
                                                                      DataKeyWord.writedDate : convertDate])
        }
    }
    
    //상대방의 댓글에 답글을 달았을 경우.
    private func setCommentNotiData(userUID : String, comment : String) {
        let owner = commentsDataArray[self.commentIndexSection].userUID
        
        if owner == userUID { //내 댓글에 내가 답글을 다는경우에는 알림이 울릴 필요가 없음.
            
        }else{//댓글 주인에게 답글 내용에 대한 알림을 넣어줌.
            guard let myName = UserDefaults.standard.string(forKey: "myName") else{return}
            
            let formatDate = DateFormatter()
            formatDate.dateFormat = "yyyy-MM-dd HH:mm"
            let convertDate = formatDate.string(from: Date()) //date형식 원하는 형태로 format
            
            db.collection("\(owner).Noti").addDocument(data: [DataKeyWord.userUID : userUID,
                                                              DataKeyWord.userName : myName,
                                                              "recipeDocumentID" : self.recipeDocumentID,
                                                              "version" : 1,
                                                              DataKeyWord.comment : comment,
                                                              DataKeyWord.writedDate : convertDate])
        }
    }
}
