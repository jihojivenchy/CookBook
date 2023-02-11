////
////  ComunicationViewController.swift
////  CookingProject
////
////  Created by 엄지호 on 2022/07/15.
////
//
//import UIKit
//import SnapKit
//import Tabman
//import Pageboy
//import Firebase
//import FirebaseFirestore
//import FirebaseStorage
//
//class ComunicationViewController: TabmanViewController {
//
////MARK: - Properties
//    let db = Firestore.firestore()
//    let storage = Storage.storage()
//
//    private var viewControllers : Array<UIViewController> = []
//    private var defaltPageNumber = 0
//
//    private let titleList = ["보기", "댓글"]
//
//    private lazy var userCutButton : UIBarButtonItem? = {
//        if let user = Auth.auth().currentUser{
//            if let userUID = UserDefaults.standard.string(forKey: "userUID"){
//                if user.uid == userUID {
//                    let button1 = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(deleteButtonPressed(_:)))
//                    return button1
//                }else{
//
//                    let button2 = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(cutButtonPressed(_:)))
//                    return button2
//                }
//            }
//        }
//
//        return nil
//    }()
//
////MARK: - LifeCycle
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.prefersLargeTitles = false
//
//        tabBarController?.tabBar.isHidden = true
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        naviBarAppearance()
//
//        let vc1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        let vc2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
//
//
//        viewControllers.append(vc1)
//        viewControllers.append(vc2)
//        self.dataSource = self
//
//        view.backgroundColor = .white
//        setBar()
//    }
//
////MARK: - ViewMethod
//    private func naviBarAppearance() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundColor = .customPink
//        navigationItem.standardAppearance = appearance
//        navigationItem.scrollEdgeAppearance = appearance
//        navigationItem.rightBarButtonItem = userCutButton
//
//        navigationItem.title = "보기"
//    }
//
//    private func setBar() {
//        let bar = TMBar.ButtonBar()
//        bar.layout.transitionStyle = .snap //Customize
//
//        // Add to view
//        addBar(bar, dataSource: self, at: .top)
//
//        bar.backgroundView.style = .blur(style: .light) //버튼 백그라운드 스타일
//        bar.layout.alignment = .centerDistributed // .center시 선택된 탭이 가운데로 오게 됨.
//        bar.layout.contentMode = .fit //버튼들의 간격설정
//
//        bar.buttons.customize { (button) in
//            button.tintColor = .lightGray
//            button.selectedTintColor = .customPink2
//            button.font = UIFont(name: "EF_Diary", size: 16) ?? .systemFont(ofSize: 16)
//            button.selectedFont = UIFont(name: "EF_Diary", size: 20) ?? .systemFont(ofSize: 20)
//        }
//
//        bar.indicator.tintColor = .customPink2
//        bar.indicator.overscrollBehavior = .compress
//    }
//
////MARK: - DataMethod
//
//    @objc private func cutButtonPressed(_ sender : UIBarButtonItem) {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        let alertAction = UIAlertAction(title: "신고하기", style: .default) { action in
//            self.performSegue(withIdentifier: "goToReport", sender: self)
//        }
//
//        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
//        let alertAction2 = UIAlertAction(title: "작성자 차단하기", style: .default) { action in
//            self.saveBlockUserData() //작성자 차단기능
//            self.navigationController?.popViewController(animated: true)
//        }
//        alertAction2.setValue(UIColor.black, forKey: "titleTextColor")
//        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//        cancel.setValue(UIColor.black, forKey: "titleTextColor")
//
//        alert.addAction(alertAction)
//        alert.addAction(alertAction2)
//        alert.addAction(cancel)
//
//        present(alert, animated: true, completion: nil)
//
//    }
//
//    private func saveBlockUserData() {
//        guard let userUID = UserDefaults.standard.string(forKey: "userUID") else{return}
//
//        if let user = Auth.auth().currentUser{
//            db.collection("Users").document(userUID).getDocument { querySnapshot, error in
//                if let e = error{
//                    print("Error get user nickname data : \(e)")
//                }else{
//                    guard let data = querySnapshot?.data() else{return}
//                    guard let userNickName = data["NickName"] as? String else{return}
//
//                    self.db.collection("\(user.uid).block").addDocument(data: ["user" : userUID,
//                                                                         "userNickName" : userNickName])
//                }
//            }
//        }
//    }//유저 차단 기능
//
//    @objc private func deleteButtonPressed(_ sender : UIBarButtonItem) {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//
//        let alertAction = UIAlertAction(title: "삭제하기", style: .default) { action in
//            self.deleteMethod()
//        }
//        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
//
//        let alertAction2 = UIAlertAction(title: "수정하기", style: .default) { action in
//            self.performSegue(withIdentifier: "goToRegister", sender: self)
//        }
//        alertAction2.setValue(UIColor.black, forKey: "titleTextColor")
//
//        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//        cancel.setValue(UIColor.black, forKey: "titleTextColor")
//
//        alert.addAction(alertAction)
//        alert.addAction(alertAction2)
//        alert.addAction(cancel)
//
//        present(alert, animated: true, completion: nil)
//    }
//
//    private func deleteMethod() {
//        let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
//
//        let alertAction = UIAlertAction(title: "삭제", style: .default) { action in
//            guard let user = Auth.auth().currentUser else{return}
//
//            if let savedTitle = UserDefaults.standard.string(forKey: "selectedTitle"){
//                self.db.collection("전체보기").whereField("Title", isEqualTo: savedTitle).whereField("user", isEqualTo: user.uid).getDocuments { snapshot, error in
//                    if let e = error{
//                        print("Error get query document : \(e)")
//                    }else{
//                        if let snapshotDocument = snapshot?.documents{
//                            for doc in snapshotDocument{
//                                let data = doc.data()
//                                guard let imageFile = data["imageFile"] as? [String] else {return} //저장된 이미지 file의 제목 가져오기
//
//                                self.imageFileDelete(title: imageFile) //저장된 이미지 삭제
//                                doc.reference.delete() //저장된 데이터 삭제
//                                self.db.collection("전체보기").document(doc.documentID).collection("댓글").document().delete() //하위 컬렉션 삭제
//
//                            }
//                            DispatchQueue.main.async {
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
//
//        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//        cancel.setValue(UIColor.black, forKey: "titleTextColor")
//
//        alert.addAction(alertAction)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)
//    }
//
//    private func imageFileDelete(title : [String]) {
//
//        for imageTitle in title {
//
//            let desertRef = storage.reference().child(imageTitle)
//
//            desertRef.delete { error in
//                if let e = error{
//                    print("Error delete file : \(e)")
//                }
//            }
//        }
//    }
//
//}
////MARK: - Extension
//extension ComunicationViewController : PageboyViewControllerDataSource, TMBarDataSource {
//
//    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
//
//        let item = TMBarItem(title: "")
//        item.title = titleList[index]
//
//
//
//        return item
//    }
//
//    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
//        return viewControllers.count
//
//    }
//
//    func viewController(for pageboyViewController: PageboyViewController,
//                        at index: PageboyViewController.PageIndex) -> UIViewController? {
//
//
//        return viewControllers[index]
//    }
//
//    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
//
//        return .at(index: defaltPageNumber)
//    }
//
//}
