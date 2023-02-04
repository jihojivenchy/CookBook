//
//  CommentsViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/22.
//

import UIKit
import SnapKit
import Firebase
import FirebaseFirestore

class CommentsViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    private var commentsModel : [CommentsModel] = []
    private var cutOffUserModel : [String] = []
    
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var commentNumber = 1
    
    private lazy var writeTextfield : UITextField = {
        let wt = UITextField()
        wt.attributedPlaceholder = NSAttributedString(string: "댓글을 남겨보세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray ?? UIColor.lightGray]) //placeholder의 컬러를 바꿔주는 코드
        wt.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) //패딩
        wt.leftViewMode = .always
        wt.layer.cornerRadius = 15
        wt.layer.borderWidth = 1
        wt.layer.borderColor = UIColor.customGray?.cgColor
        wt.clipsToBounds = true
        wt.clearButtonMode = .always
        wt.textColor = .black
       
        return wt
    }()
    
    private lazy var sendButton : UIButton = {
        let sb = UIButton()
        sb.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        sb.tintColor = .white
        sb.backgroundColor = .customPink
        sb.layer.borderColor = UIColor.customPink?.cgColor
        sb.layer.borderWidth = 1
        sb.layer.cornerRadius = 15
        sb.addTarget(self, action: #selector(findNickName(_:)), for: .touchUpInside)
        
        return sb
    }()
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewChange()
        tableView.register(ComunicationCell.self, forCellReuseIdentifier: ComunicationCell.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))//개체들이 모두 스크롤뷰 위에 존재하기 때문에 스크롤뷰 특성 상 touchBegan함수가 실행되지 않는다. 따라서 스크롤뷰에 대한 핸들러 캐치를 등록해주어야 한다.
        
        keyboardChange()
        
    }
    
    
    
//MARK: - ViewMethod
    private func keyboardChange() {
        
        //키보드가 위로올라 올 때 텍스트필드를 가리는것을 방지하기 위한 코드
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc private func keyboardWillShow(_ sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y -= keyboardHeight
            }

    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0   //키보드가 내려가면서 뷰를 원상복귀
    }
    
    
    private func viewChange() {
        view.backgroundColor = .white
        uploadMessageData()
        
        view.addSubview(writeTextfield)
        writeTextfield.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaInsets).inset(30)
            make.left.equalTo(view).inset(10)
            make.height.equalTo(40)
            make.right.equalTo(view).inset(50)
        }
        
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaInsets).inset(30)
            make.left.equalTo(writeTextfield.snp_rightMargin).offset(10)
            make.height.equalTo(40)
            make.right.equalTo(view).inset(10)
        }
        
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets)
            make.left.right.equalTo(view)
            make.bottom.equalTo(writeTextfield.snp_topMargin).offset(-10)
        }
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }//스크롤뷰 터치 시에 endEditing 발생
 
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
    
    private func uploadMessageData() { //해당 글의 도큐먼트아이디를 가져온 후 하위 컬렉션인 댓글 데이터를 가져오기.
        getBlockedUserData()
        
        guard let savedTitle = UserDefaults.standard.string(forKey: "selectedTitle") else{return}
        guard let savedDate = UserDefaults.standard.string(forKey: "selectedDate") else{return}
        
        db.collection("전체보기").whereField("Title", isEqualTo: savedTitle).whereField("date", isEqualTo: savedDate).getDocuments { querySnapshot, error in
            if let e = error {
                print("Error find data : \(e)")
            }else{
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument{
                        
                        self.db.collection("전체보기").document(doc.documentID).collection("댓글").order(by: "timeStamp", descending: false).addSnapshotListener { snapshot, error in
                            if let e2 = error{
                                print("Error find message data : \(e2)")
                            }else{
                                self.commentsModel = []
                                if let snap = snapshot?.documents{ //도큐먼트 접근
                                    for docs in snap{
                                        let data = docs.data() //도큐먼트 내 데이터에 접근
                                        
                                        if let senderData = data["sender"] as? String, let messageData = data["message"] as? String, let dateData = data["date"] as? String, let nickNameData = data["usernickName"] as? String, let documentIdData = data["documentId"] as? String {
                                            //가져오기 성공했을 때 UserModel에 추가
                                            
                                            let findData = CommentsModel(userId: senderData, messages: messageData, saveDate: dateData, nickName: nickNameData, documentId: documentIdData)
                                            
                                            if self.cutOffUserModel.contains(senderData){ //가져온 데이터가 차단한 유저라면 추가하지 않음.
                                            }else{
                                                self.commentsModel.append(findData)
                                            }
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
        
    @objc private func findNickName(_ sender : UIButton) {
        if let user = Auth.auth().currentUser{
            db.collection("Users").document(user.uid).getDocument { querySnapshot, error in
                if let e = error{
                    print("Error find user nickname : \(e)")
                }else{
                    guard let userData = querySnapshot?.data() else {return}
                    
                    if let userNickName = userData["NickName"] as? String{
                        self.sendButtonPressed(userNickName: userNickName)
                    }
                }
            }
        }else{
            loginAlert()
        }
    }
    
    private func sendButtonPressed(userNickName : String) {
        
        let date = Date()
        let formatDate = DateFormatter()
        formatDate.dateFormat = "yyyy-MM-dd HH:mm"
        let convertDate = formatDate.string(from: date) //date형식 원하는 형태로 format
        
        guard let savedTitle = UserDefaults.standard.string(forKey: "selectedTitle") else{return}
        guard let savedDate = UserDefaults.standard.string(forKey: "selectedDate") else{return}
        
        if let user = Auth.auth().currentUser{
            if let message = writeTextfield.text{
                if message != ""{
                    db.collection("전체보기").whereField("Title", isEqualTo: savedTitle).whereField("date", isEqualTo: savedDate).getDocuments { querySnapshot, error in
                        if let e = error {
                            print("Error find data : \(e)")
                        }else{
                            if let snapshotDocument = querySnapshot?.documents{
                                for doc in snapshotDocument{
                                    let data = doc.data()
                                    
                                    if let userData = data["user"] as? String, let writedDate = data["date"] as? String{
                                        self.userSignalData(userUID: userData, title: savedTitle, date: convertDate, writedDate: writedDate, userNickName: userNickName)
                                    }
                                    
                                    self.db.collection("전체보기").document(doc.documentID).collection("댓글").addDocument(data: ["sender" : user.uid,
                                                            "date" : convertDate,
                                                            "message" : message,
                                                            "usernickName" : userNickName,
                                                            "documentId" : doc.documentID,
                                                            "timeStamp" : Date().timeIntervalSince1970])
                                    
                                }
                                DispatchQueue.main.async {
                                    self.writeTextfield.text = ""
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    private func userSignalData(userUID : String, title : String, date : String, writedDate : String, userNickName : String) {
        if let user = Auth.auth().currentUser{
            if userUID != user.uid{ //만약 글의 주인정보와 댓글을 단 사람정보가 다를 경우 글 주인이름으로 컬렉션달림.
                db.collection(userUID).addDocument(data: ["Title" : title,
                                                          "sendedUser" : user.uid,
                                                          "ownerUser" : userUID,
                                                          "date" : date,
                                                          "writedDate" : writedDate,
                                                          "userNickName" : userNickName])
            }else{
                print("정보가 다르다.")
            }
        }else{
            
        }
    }
    
    private func loginAlert() {
        let alert = UIAlertController(title: "로그인이 필요합니다", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteAlert(indexPath : IndexPath) {
        let alert = UIAlertController(title: "댓글", message: "삭제하시겠습니까?", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "삭제", style: .default) { action in
            guard let saveDocumentId = UserDefaults.standard.string(forKey: "selectedDocument") else{return}
            guard let saveMessage = UserDefaults.standard.string(forKey: "selectedMessage") else{return}
            
            self.deleteMethod(saveDocumentId: saveDocumentId, saveMessage: saveMessage)
            self.commentsModel.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteMethod(saveDocumentId : String, saveMessage : String) { //댓글 삭제 기능
        db.collection("전체보기").document(saveDocumentId).collection("댓글").whereField("message", isEqualTo: saveMessage).getDocuments { querySnapshot, error in
            if let e = error {
                print("Error getDocument : \(e)")
            }else{
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument{
                        doc.reference.delete()
                    }
                }
                
            }
        }
        
    }
    
    private func userBlockAlert(userUid : String){ //차단기능
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let alertAction = UIAlertAction(title: "작성자 차단하기", style: .default) { action in
            self.saveBlockUserData(userUID: userUid)
        }
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteAndBlockUserAlert(indexPath : IndexPath , userUid : String) { //글의 주인은 댓글단 유저차단, 댓글 삭제 모든 권한을 가진다.
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "댓글 삭제", style: .default) { action in
            self.deleteAlert(indexPath: indexPath)
        }
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        let alertAction2 = UIAlertAction(title: "작성자 차단하기", style: .default) { action in
            self.saveBlockUserData(userUID: userUid)
        }
        alertAction2.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        alert.addAction(alertAction2)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func saveBlockUserData(userUID : String) {
        
        if let user = Auth.auth().currentUser{
            db.collection("Users").document(userUID).getDocument { querySnapshot, error in
                if let e = error{
                    print("Error get user nickname data : \(e)")
                }else{
                    guard let data = querySnapshot?.data() else{return}
                    guard let userNickName = data["NickName"] as? String else{return}
                    
                    self.db.collection("\(user.uid).block").addDocument(data: ["user" : userUID,
                                                                         "userNickName" : userNickName])
                }
            }
        }
    }//유저 차단 기능

}

//MARK: - Extension
extension CommentsViewController : UITableViewDataSource {
    //cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ComunicationCell.cellIdentifier, for: indexPath) as! ComunicationCell
        
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.inputLabel.text = commentsModel[indexPath.row].messages
        cell.timeLable.text = commentsModel[indexPath.row].saveDate
        cell.idLabel.text = commentsModel[indexPath.row].nickName
        cell.userUidLabel.text = commentsModel[indexPath.row].userId
        cell.documentIdLabel.text = commentsModel[indexPath.row].documentId
        
        cell.idImage.image = UIImage(named: "요리사")
        
        return cell
    }
    
    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cHeaderView = ComunicationHeader()
        cHeaderView.label1.text = "달린댓글(\(commentsModel.count))"
    
        return cHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
}

extension CommentsViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = tableView.cellForRow(at: indexPath) as? ComunicationCell else{return}
        guard let selectedUserUid = selectedItem.userUidLabel.text else{return}
        
        guard let ownerUid = UserDefaults.standard.string(forKey: "userUID") else{return} //글 주인을 확인하는 코드.
        
        if let selectedMessage = selectedItem.inputLabel.text{
            UserDefaults.standard.set(selectedMessage, forKey: "selectedMessage")
        }//댓글 삭제할 때 맞는 데이터 찾아오기 위해 message저장
        
        if let selectedDocument = selectedItem.documentIdLabel.text{
            UserDefaults.standard.set(selectedDocument, forKey: "selectedDocument")
        } //댓글 삭제할 때 맞는 데이터 찾아오기 위해 도큐먼트저장
        
        
        if let user = Auth.auth().currentUser{
            
            if user.uid == selectedUserUid{//해당 댓글이 내가 작성한 댓글일 때
                deleteAlert(indexPath : indexPath)
                
            }else if user.uid == ownerUid{ //해당 글이 내 글일 때
                deleteAndBlockUserAlert(indexPath: indexPath, userUid: selectedUserUid)
            }else{
                userBlockAlert(userUid: selectedUserUid)
            }
        }else{ //로그인 필요
            loginAlert()
        }
        
        
        
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
    }
}

extension CommentsViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
}
