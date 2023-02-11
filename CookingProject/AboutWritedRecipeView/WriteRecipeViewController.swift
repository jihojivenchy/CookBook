//
//  WriteRecipeViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/26.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import BSImagePicker
import Photos
import SCLAlertView

final class WriteRecipeViewController: UIViewController {
//MARK: - Properties
    private let storage = Storage.storage()
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
    
    final var sendedArray : [String] = ["", "", "", ""]
    final var userName = String()
    final var selectedTime = String()
    final var ingredients = String()
    private var contentsArray : [String] = ["", "", "", "", "", "", "", "", "", ""] //textview 작성 내용을 담는 곳
    
    //imagePicker
    private var selectedPhAsset : [PHAsset] = []
    private var photoImageArray : [UIImage] = []
    
    
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
        
        view.backgroundColor = .customGray
        
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
        if self.photoImageArray.count != 0 {
            self.setDataAlert()
        }else{
            CustomAlert.show(title: "오류", subMessage: "사진을 추가해주세요.")
        }
    }
    
    
//MARK: - KeyBoard Notification Method
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
//MARK: - Extension

extension WriteRecipeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photoImageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier, for: indexPath) as! RecipeTableViewCell
        
        cell.contentView.isUserInteractionEnabled = false
        cell.stepLabel.text = "Step \(indexPath.row + 1)"
        
        cell.textIndex = indexPath.row
        cell.textDelegate = self
        cell.recipeTextView.text = self.contentsArray[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    //headerview
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let recipeHeaderView = RecipeHeaderView()
        
        recipeHeaderView.photoImageArray = self.photoImageArray
        recipeHeaderView.sendedArray = self.sendedArray
        recipeHeaderView.delegate = self
        recipeHeaderView.buttonDelegate = self
        
        return recipeHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
}

extension WriteRecipeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

//image picker
extension WriteRecipeViewController : PhotoHeaderTouchDelegate {
    func tapHeaderView() {
        findImage()
    }
    
    private func findImage(){
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        
        let imagePicker = ImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.settings.selection.max = 10
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.theme.selectionFillColor = .customSignature ?? .white
        imagePicker.doneButton.tintColor = .customSignature
        imagePicker.doneButtonTitle = "Done"
        imagePicker.cancelButton.tintColor = .customSignature
        
        presentImagePicker(imagePicker, select: { (asset) in
            //사진 하나씩 선택할 때마다 실행되는 내용
            
        }, deselect: { (asset) in
            //선택 해제했을 때 실행되는 내용
            
        }, cancel: { (asset) in
            self.dismiss(animated: true, completion: nil) //cancel버튼 실행되는 내용
            
        }, finish: { (asset) in
            
            self.selectedPhAsset.removeAll()
            
            for i in asset{
                self.selectedPhAsset.append(i)
            }
            
            self.convertAssetToImage(asset: self.selectedPhAsset, option: options)
            
        })
    }
    
    private func convertAssetToImage(asset : [PHAsset], option : PHImageRequestOptions) { //PHAsset을 이미지타입으로 변경
        
        if asset.count != 0 {
            
            for i in 0 ..< asset.count {
                let imageManager = PHImageManager.default()
                
                option.isSynchronous = true
                option.deliveryMode = .opportunistic
                
                var thumbnail = UIImage()
                imageManager.requestImage(for: asset[i],
                                          targetSize: CGSize(width: 80, height: 80),
                                          contentMode: .aspectFill,
                                          options: option) { result, info in
                    
                    thumbnail = result!
                }
                
                guard let data = thumbnail.jpegData(compressionQuality: 0.8) else{return}
                guard let newImage = UIImage(data: data) else{return}
                
                
                if photoImageArray.count < 10 {
                    self.photoImageArray.append(newImage as UIImage)
                }
            }
            
            DispatchQueue.main.async {
                self.recipeTableView.reloadData()
            }
        }
    }
}

//delete image
extension WriteRecipeViewController : PhotoDeleteButtonDelegate {
    func delete(index: Int) {
        self.photoImageArray.remove(at: index)
        self.contentsArray = ["", "", "", "", "", "", "", "", "", ""]
        self.recipeTableView.reloadData()
    }
}

//textview delegate
extension WriteRecipeViewController : RecipeTextViewDelegate {
    func startEditing(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.recipeTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func sendText(index: Int, text: String) {
        self.contentsArray[index] = text
    }
}

//alert
extension WriteRecipeViewController {
    private func setDataAlert() {
        let appearence = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: KeyWord.CustomFont, size: 17) ?? .boldSystemFont(ofSize: 17), kTextFont: UIFont(name: KeyWord.CustomFont, size: 13) ?? .boldSystemFont(ofSize: 13), showCloseButton: false)
        let alert = SCLAlertView(appearance: appearence)
        
        alert.addButton("확인", backgroundColor: .customSignature, textColor: .white) {
            self.setUploadImage()
        }
        
        alert.addButton("취소", backgroundColor: .customSignature, textColor: .white) {
            
        }
        
        alert.showSuccess("저장",
                          subTitle: "레시피를 저장하시겠습니까?",
                          colorStyle: 0xFFB6B9,
                          colorTextButton: 0xFFFFFF)
    }
}

//Set Wrtied Recipe Data
extension WriteRecipeViewController {
    private func setUploadImage() {
        CustomLoadingView.shared.startLoading(alpha: 0.5)
        
        var completionCount = 0 //for문이 끝나는 시점을 알기 위해서.
        var saveUrlArray = [String](repeating: "", count: photoImageArray.count)  //image url들을 담는 공간
        var fileTitleArray : [String] = [] //image file의 제목
        
        for (index, image) in photoImageArray.enumerated() {
            
            let titleDate = Date().timeIntervalSince1970
            
            var data = Data()
            data = image.jpegData(compressionQuality: 0.8)!
            
            let filePath = "saveImage\(titleDate)"
            let storageRefChild = self.storage.reference().child(filePath)
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            storageRefChild.putData(data, metadata: metaData) { (metadata, error) in
                if let e = error{
                    print("Error saved image : \(e)")
                    DispatchQueue.main.async {
                        CustomLoadingView.shared.stopLoading()
                    }
                    
                }else{
                    storageRefChild.downloadURL { url, error in
                        if let e = error{
                            print("Error downloadURL : \(e)")
                            DispatchQueue.main.async {
                                CustomLoadingView.shared.stopLoading()
                            }
                            
                        }else{
                            
                            guard let urlString = url?.absoluteString else{return}
                            
                            if index == 0 {
                                saveUrlArray[0] = urlString
                                
                            }else if index == 1 {
                                saveUrlArray[1] = urlString
                                
                            }else if index == 2 {
                                saveUrlArray[2] = urlString
                                
                            }else if index == 3 {
                                saveUrlArray[3] = urlString
                                
                            }else if index == 4 {
                                saveUrlArray[4] = urlString
                                
                            }else if index == 5 {
                                saveUrlArray[5] = urlString
                                
                            }else if index == 6 {
                                saveUrlArray[6] = urlString
                                
                            }else if index == 7 {
                                saveUrlArray[7] = urlString
                                
                            }else if index == 8 {
                                saveUrlArray[8] = urlString
                                
                            }else{
                                saveUrlArray[9] = urlString
                            }
                            
                            fileTitleArray.append(filePath)
                            
                            if self.photoImageArray.count - 1 == completionCount{ //반복문이 모두 끝날 때 data 저장
                                self.setWriteData(url: saveUrlArray, imageFileTitle: fileTitleArray)
                                
                            }else{
                                completionCount += 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func setWriteData(url : [String], imageFileTitle : [String]) {
        let contents = filteringContantsArray()
        
        let dfMatter = DateFormatter()
        dfMatter.dateFormat = "yyyy-MM-dd HH:mm"
        let convertDate = dfMatter.string(from: Date()) //date형식 원하는 형태로 format
        
        guard let user = Auth.auth().currentUser else{return}
        
        self.db.collection("전체보기").addDocument(data: ["Title" : self.sendedArray[2],
                                                      "ingredients" : self.ingredients,
                                                      "segment" : self.sendedArray[1],
                                                      "tema" : self.sendedArray[0],
                                                      "comments" : 0,
                                                      "heartPeople" : FieldValue.arrayUnion([]),
                                                      "time" : self.selectedTime,
                                                      "contents" : FieldValue.arrayUnion(contents),
                                                      "user" : user.uid,
                                                      "date" : convertDate,
                                                      "userNickName" : self.userName,
                                                      "url" : FieldValue.arrayUnion(url),
                                                      "imageFile" : FieldValue.arrayUnion(imageFileTitle)])
        
        DispatchQueue.main.async {
            CustomLoadingView.shared.stopLoading()
            self.navigationController?.pushViewController(FinishViewController(), animated: true)
        }
    } //data 저장을 위한 method
    
    private func filteringContantsArray() -> Array<String> { //컨텐츠를 작성하지 않은 배열들은 필터링해줌.
        let resultArray = self.contentsArray.filter {$0 != ""}
        return resultArray
    }
}


