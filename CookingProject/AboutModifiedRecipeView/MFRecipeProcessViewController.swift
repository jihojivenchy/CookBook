//
//  MFRecipeProcessViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/17.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import BSImagePicker
import Photos
import SCLAlertView

final class MFRecipeProcessViewController: UIViewController {
//MARK: - Properties
    final var modifyRecipeData = ModifyRecipeDataModel(foodName: "", foodCategory: "", foodLevel: "", foodTime: "", contents: [], ingredients: "", urlArray: [], documentID: "")
    
    private let db = Firestore.firestore()
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private lazy var saveButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(saveButtonPressed(_:)))
        
        return sb
    }()
    
    private let recipeTableView = UITableView(frame: .zero, style: .grouped)
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        
        addSubViews()
        
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        recipeTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.identifier)
        recipeTableView.rowHeight = 150
        recipeTableView.separatorStyle = .none
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))//개체들이 모두 스크롤뷰 위에 존재하기 때문에 스크롤뷰 특성 상 touchBegan함수가 실행되지 않는다. 따라서 스크롤뷰에 대한 핸들러 캐치를 등록해주어야 한다.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotifications()
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func addSubViews() {
        
        view.backgroundColor = .customWhite
        
        view.addSubview(recipeTableView)
        recipeTableView.backgroundColor = .clear
        recipeTableView.showsVerticalScrollIndicator = false
        recipeTableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }//스크롤뷰 터치 시에 endEditing 발생
    
    
    //MARK: - ButtonMethod
    @objc private func saveButtonPressed(_ sender : UIBarButtonItem) {
        self.view.endEditing(true)
        self.setDataAlert()
    }
}
//MARK: - Extension
extension MFRecipeProcessViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifyRecipeData.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier, for: indexPath) as! RecipeTableViewCell
        
        cell.contentView.isUserInteractionEnabled = false
        cell.stepLabel.text = "Step \(indexPath.row + 1)"
        
        cell.textIndex = indexPath.row
        cell.textDelegate = self
        cell.recipeTextView.text = self.modifyRecipeData.contents[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    //headerview
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let recipeHeaderView = RecipeHeaderView()
        
        let array = [modifyRecipeData.foodCategory, modifyRecipeData.foodLevel, modifyRecipeData.foodName, ""]
        
        recipeHeaderView.photoURLArray = modifyRecipeData.urlArray
        recipeHeaderView.photoImageArray = []
        recipeHeaderView.sendedArray = array
        recipeHeaderView.delegate = self
        recipeHeaderView.buttonDelegate = self
        
        return recipeHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
}

extension MFRecipeProcessViewController : UITableViewDelegate {
}

//image picker
extension MFRecipeProcessViewController : PhotoHeaderTouchDelegate {
    func tapHeaderView() {
        CustomAlert.show(title: "수정불가", subMessage: "이미지 수정 불가")
    }
}

//delete image
extension MFRecipeProcessViewController : PhotoDeleteButtonDelegate {
    func delete(index: Int) {
        CustomAlert.show(title: "수정불가", subMessage: "이미지 수정 불가")
    }
}

//textview delegate
extension MFRecipeProcessViewController : RecipeTextViewDelegate {
    func startEditing(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.recipeTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func sendText(index: Int, text: String) {
        self.modifyRecipeData.contents[index] = text
        print(modifyRecipeData.contents)
    }
}

//alert
extension MFRecipeProcessViewController {
    private func setDataAlert() {
        let appearence = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: FontKeyWord.CustomFont, size: 17) ?? .boldSystemFont(ofSize: 17), kTextFont: UIFont(name: FontKeyWord.CustomFont, size: 13) ?? .boldSystemFont(ofSize: 13), showCloseButton: false)
        let alert = SCLAlertView(appearance: appearence)
        
        alert.addButton("확인", backgroundColor: .customSignature, textColor: .white) {
            self.setWriteData()
        }
        
        alert.addButton("취소", backgroundColor: .customSignature, textColor: .white) {
            
        }
        
        alert.showSuccess("수정",
                          subTitle: "수정한 레시피를 저장하시겠습니까?",
                          colorStyle: 0xFFB6B9,
                          colorTextButton: 0xFFFFFF)
    }

    private func setWriteData() {
        self.db.collection("전체보기").document(modifyRecipeData.documentID).updateData(
            [DataKeyWord.foodName : modifyRecipeData.foodName,
             DataKeyWord.ingredients : modifyRecipeData.ingredients,
             DataKeyWord.foodLevel : modifyRecipeData.foodLevel,
             DataKeyWord.foodCategory : modifyRecipeData.foodCategory,
             DataKeyWord.foodTime : modifyRecipeData.foodTime,
             DataKeyWord.contents : modifyRecipeData.contents]) { error in
                 if let e = error{
                     print("Error 수정한 데이터 업데이트 실패 : \(e.localizedDescription)")
                 }else{
                     DispatchQueue.main.async {
                         self.navigationController?.popToRootViewController(animated: true)
                     }
                 }
             }
    }
}

//MARK: - KeyBoard Notification Method
//키보드 관련 메서드
extension MFRecipeProcessViewController {
    
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
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.recipeTableView.snp.remakeConstraints { make in
                        make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
                        make.bottom.equalToSuperview().inset(keyboardHeight)
                    }
                    
                })
            }
            
        }
        
        // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
        @objc private func keyboardWillHide(_ noti: NSNotification){
            UIView.transition(with: self.recipeTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.recipeTableView.snp.remakeConstraints { make in
                    make.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
                }
            })
        }
        
        // 노티피케이션을 제거하는 메서드
        private func removeKeyboardNotifications(){
            // 키보드가 나타날 때 앱에게 알리는 메서드 제거
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
            // 키보드가 사라질 때 앱에게 알리는 메서드 제거
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
}
