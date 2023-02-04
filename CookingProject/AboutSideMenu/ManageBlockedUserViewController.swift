//
//  ManageBlockedUserViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/16.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class ManageBlockedUserViewController: UIViewController {
    
//MARK: - Properties
    private let db = Firestore.firestore()
    private var blockUserModel : [BlockUserModel] = []
    
    private let tableView = UITableView(frame: .zero, style: .grouped)

//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        naviBarAppearance()
        
        viewChange()
        tableView.register(BlockUserTableViewCell.self, forCellReuseIdentifier: BlockUserTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        
        getBlockedUserData()
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "차단목록"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func viewChange() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaInsets)
            make.right.left.equalTo(view)
        }
        
    }
    
//MARK: - DataMethod
    private func getBlockedUserData() { //차단유저 가져오기
        if let user = Auth.auth().currentUser{
            db.collection("\(user.uid).self").addSnapshotListener { querySnapshot, error in
                if let e = error{
                    print("Error find Cut-Off User Data : \(e)")
                }else{
                    self.blockUserModel = []
                    if let snapShotDocuments = querySnapshot?.documents{
                        for doc in snapShotDocuments{
                            let data = doc.data()
                            
                            if let userUidData = data["user"] as? String, let nickNameData = data["userNickName"] as? String{
                                
                                let findData = BlockUserModel(userUid: userUidData, userNickName: nickNameData)
                                self.blockUserModel.append(findData)
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
    
    private func unBlockMethod(indexPath : IndexPath, saveUserUid : String){
        let alert = UIAlertController(title: "차단을 해제하시겠습니까?", message: nil, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default) { action in
            
            self.blockUserModel.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let user = Auth.auth().currentUser{
                self.db.collection("\(user.uid).self").whereField("user", isEqualTo: saveUserUid).getDocuments { querySnapshot, error in
                    if let e = error{
                        print("Error query userUidData : \(e)")
                    }else{
                        guard let snapshotDocuments = querySnapshot?.documents else{return}
                        
                        for doc in snapshotDocuments{
                            doc.reference.delete()
                        }
                    }
                }
            }
            
        }
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    

    

}

//MARK: - Extension
extension ManageBlockedUserViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockUserModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BlockUserTableViewCell.identifier, for: indexPath) as! BlockUserTableViewCell
        
        cell.userNameLabel.text = blockUserModel[indexPath.row].userNickName
        cell.userUidLabel.text = blockUserModel[indexPath.row].userUid
        cell.accessoryType = .checkmark
        cell.tintColor = .customPink
        
        return cell
    }
    
    
}

extension ManageBlockedUserViewController : UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = tableView.cellForRow(at: indexPath) as? BlockUserTableViewCell else{return}
        guard let selectedUser = selectedItem.userUidLabel.text else{return}
        
        unBlockMethod(indexPath: indexPath, saveUserUid: selectedUser)
        
        tableView.deselectRow(at: indexPath, animated: true) //cell을 클릭했을 때 애니메이션 구현
    }
}
