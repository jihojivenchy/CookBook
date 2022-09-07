//
//  ModifyViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/08.
//

import UIKit
import SnapKit
import PhotosUI
import Firebase
import FirebaseFirestore
import UserNotifications
import FirebaseStorage

class SaveCreatedDataViewController: UIViewController {
    
//MARK: - Properties
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    private let textViewHolder = "재료를 입력해주세요 ex) 양파/2개, 대파/2쪽"

    private var titleText = ""
    private var ingredientText = ""
    private var seguementText = "초급"
    private var temaText = ""
    private var contentsText = ""
    
    private let scrollView = UIScrollView()
    
    private let titleLabel = UILabel()
    private lazy var titleTextField : UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요(10글자 이하)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray ?? UIColor.lightGray]) //placeholder의 컬러를 바꿔주는 코드
        tf.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.customGray?.cgColor
        tf.clipsToBounds = true
        tf.clearButtonMode = .always
        tf.delegate = self
        tf.textColor = .black
        
        return tf
    }()
    
    private let ingredientsLabel = UILabel()
    private lazy var ingredientsTextView : UITextView = {
        let tv = UITextView()
        tv.returnKeyType = .next
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.customGray?.cgColor
        tv.font = .systemFont(ofSize: 20, weight: .black)
        tv.text = textViewHolder
        tv.textColor = .customGray
        tv.delegate = self
        
        return tv
    }()

    private let seguementLabel = UILabel()
    private lazy var segmentButton : UISegmentedControl = {
        let segButton = UISegmentedControl(items: ["초급", "중급", "고급"])
        segButton.selectedSegmentTintColor = .customPink2
        segButton.selectedSegmentIndex = 0
        segButton.addTarget(self, action: #selector(segmentPressed(_:)), for: .valueChanged)

        return segButton
    }()
    
    private let temaLabel = UILabel()
    private lazy var pickerField : UITextField = {
        let pf = UITextField()
        pf.backgroundColor = .white
        pf.attributedPlaceholder = NSAttributedString(string: "테마를 선택해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray ?? UIColor.lightGray])
        pf.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        pf.leftViewMode = .always
        pf.clipsToBounds = true
        pf.textColor = .black
        pf.layer.cornerRadius = 10
        pf.layer.borderWidth = 1
        pf.layer.borderColor = UIColor.customGray?.cgColor
        pf.font = .systemFont(ofSize: 20)
        
        return pf
    }()
    private let titlePickerArray = ["한식", "중식", "양식", "일식", "간식", "채식", "퓨전", "분식", "안주"]
    
    private let contentsLabel = UILabel()
    private lazy var contentTextView : UITextView = {
        let tv = UITextView()
        tv.returnKeyType = .next
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.customGray?.cgColor
        tv.font = .systemFont(ofSize: 20, weight: .black)
        tv.textColor = .black
        
        return tv
    }()
    
    private let photoLabel = UILabel()
    private lazy var photoCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        
        return cv
    }()
    
    var photoImageArray : [UIImage] = []
    
    private let view1 = UIView()
    private let label1 = UILabel()
    
    
    
    private lazy var saveButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(clearButtonPressed(_:)))
        
        return button
    }()
    
    private lazy var photoButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .done, target: self, action: #selector(imageFindButtonPressed(_:)))
        return button
    }()
    
    private lazy var indicatorView : UIActivityIndicatorView = {
       let ia = UIActivityIndicatorView()
        ia.hidesWhenStopped = true
        ia.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        ia.center = self.scrollView.center
        ia.style = .large
        
        return ia
    }()
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItems = [saveButton, photoButton]
        navigationTitleCustom()
        
        viewChange()
        createPicker()
        dismissPickerView()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))//개체들이 모두 스크롤뷰 위에 존재하기 때문에 스크롤뷰 특성 상 touchBegan함수가 실행되지 않는다. 따라서 스크롤뷰에 대한 핸들러 캐치를 등록해주어야 한다.
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
    }

//MARK: - ViewMethod
    private func viewChange() {
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.indicatorStyle = .white
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets)
            make.right.left.equalTo(view)
            make.bottom.equalTo(view.safeAreaInsets)
        }
        
        scrollView.addSubview(titleLabel)
        titleLabel.text = "제목"
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textColor = .customPink2
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView).inset(20)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(titleTextField)
        titleTextField.backgroundColor = .white
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(scrollView).inset(20)
            make.left.equalTo(titleLabel.snp_rightMargin).offset(15)
            make.right.equalTo(view).inset(10)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(seguementLabel)
        seguementLabel.text = "난이도"
        seguementLabel.font = .systemFont(ofSize: 20)
        seguementLabel.textColor = .customPink2
        seguementLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(30)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(segmentButton)
        segmentButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(30)
            make.left.equalTo(seguementLabel.snp_rightMargin).offset(20)
            make.right.equalTo(view).inset(10)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(temaLabel)
        temaLabel.text = "테마선택"
        temaLabel.font = .systemFont(ofSize: 20)
        temaLabel.textColor = .customPink2
        temaLabel.snp.makeConstraints { make in
            make.top.equalTo(seguementLabel.snp_bottomMargin).offset(34)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(pickerField)
        pickerField.snp.makeConstraints { make in
            make.top.equalTo(seguementLabel.snp_bottomMargin).offset(34)
            make.left.equalTo(temaLabel.snp_rightMargin).offset(20)
            make.right.equalTo(view).inset(10)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(ingredientsLabel)
        ingredientsLabel.text = "재료"
        ingredientsLabel.font = .systemFont(ofSize: 20)
        ingredientsLabel.textColor = .customPink2
        ingredientsLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerField.snp_bottomMargin).offset(30)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(ingredientsTextView)
        ingredientsTextView.backgroundColor = .white
        ingredientsTextView.snp.makeConstraints { make in
            make.top.equalTo(ingredientsLabel.snp_bottomMargin).offset(15)
            make.left.right.equalTo(view).inset(10)
            make.height.equalTo(250)
        }
        
        scrollView.addSubview(contentsLabel)
        contentsLabel.text = "조리방법"
        contentsLabel.textColor = .customPink2
        contentsLabel.font = .systemFont(ofSize: 20)
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredientsTextView.snp_bottomMargin).offset(30)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp_bottomMargin).offset(20)
            make.left.right.equalTo(view).inset(10)
            make.height.equalTo(330)
            
        }
        
        scrollView.addSubview(view1)
        view1.backgroundColor = .white
        view1.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp_bottomMargin).offset(20)
            make.left.right.equalTo(view)
            make.height.equalTo(330)
            make.bottom.equalTo(scrollView).inset(20)
        }
        
        view1.addSubview(photoLabel)
        photoLabel.text = "사진"
        photoLabel.font = .systemFont(ofSize: 18)
        photoLabel.textColor = .customPink2
        photoLabel.snp.makeConstraints { make in
            make.top.equalTo(view1).inset(10)
            make.left.right.equalTo(view1).inset(20)
            make.height.equalTo(30)
        }
        
        view1.addSubview(photoCollectionView)
        photoCollectionView.layer.borderWidth = 1
        photoCollectionView.layer.borderColor = UIColor.customGray?.cgColor
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(photoLabel.snp_bottomMargin).offset(15)
            make.left.right.equalTo(view1)
            make.height.equalTo(150)
        }
        
        view1.addSubview(label1)
        label1.text = "요리도감"
        label1.textColor = .customPink
        label1.textAlignment = .center
        label1.font = .systemFont(ofSize: 20)
        label1.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp_bottomMargin).offset(90)
            make.centerX.equalTo(view1)
            make.height.equalTo(40)
        }
        
        
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }//스크롤뷰 터치 시에 endEditing 발생
    
    private func navigationTitleCustom() {
        let titleName = UILabel()
        titleName.text = "게시글 작성"
        titleName.font = UIFont(name: "EF_Diary", size: 20)
        titleName.textAlignment = .center
        titleName.textColor = .black
        titleName.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [titleName])
        stackView.axis = .horizontal
        stackView.frame.size.width = titleName.frame.width
        stackView.frame.size.height = titleName.frame.height
        
        navigationItem.titleView = stackView
        
    }
    
    private func sendNotification(){
        let content = UNMutableNotificationContent()
        content.title = "요리도감"
        content.body = "새로운 글이 올라왔어요!"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "userNotification", content: content, trigger: trigger)
        
        self.notificationCenter.add(request) { error in
            if let e = error {
                print("Notification Error : \(e) ")
            }
        }
    }
    
    private func createPicker() { //pickerview생성
        let temaPicker = UIPickerView()
        temaPicker.dataSource = self
        temaPicker.delegate = self
        pickerField.inputView = temaPicker
    }
    
    private func dismissPickerView() { //toolbar를 통해 나옴
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button1 = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(choiceButtonPressed(_:)))
        toolBar.setItems([button1], animated: true)
        toolBar.isUserInteractionEnabled = true
        pickerField.inputAccessoryView = toolBar
    }
    
    @objc private func choiceButtonPressed(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }//선택버튼누르면 사라짐
    
    
    
//MARK: - ButtonMethod
    @objc private func segmentPressed(_ sender : UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            seguementText = "초급"
        case 1:
            seguementText = "중급"
        case 2:
            seguementText = "고급"
        default:
            return
        }
    }
    
    @objc private func clearButtonPressed(_ sender : UIButton){
        guard let title = titleTextField.text, let ingredient = ingredientsTextView.text, let tema = pickerField.text, let contents = contentTextView.text else {return}
        
        if title != "", ingredient != textViewHolder, ingredient != "", tema != "", contents != "", photoImageArray != [] {
            
            self.titleText = title
            self.ingredientText = ingredient
            self.temaText = tema
            self.contentsText = contents
            
            if Auth.auth().currentUser != nil{ //로그인 여부확인
                self.saveData()
            }else{
                self.dataError(title: "로그인오류", message: "로그인해주세요")
            }
            
        }else{
            dataError(title: "작성오류", message: "모든 정보란에 정보를 기입해주세요")
        }
    }
    
    @objc private func deleteButtonPressed(_ sender : UIButton){ //collectionview photo delete method
        photoCollectionView.deleteItems(at: [IndexPath.init(row: sender.tag, section: 0)])
        photoImageArray.remove(at: sender.tag)
        photoCollectionView.reloadData()
    }
    
    @available(iOS 14, *)
        @objc private func imageFindButtonPressed(_ sender : UIBarButtonItem){
            var configuration = PHPickerConfiguration()
            configuration.selection = .ordered
            configuration.selectionLimit = 5 //선택할 수 있는 개수
            configuration.filter = .any(of: [.images]) //갤러리에서 가져올 때 제한할 종류
            let picker = PHPickerViewController(configuration : configuration)
            picker.delegate = self
            
            self.present(picker, animated: true, completion: nil)
        
        }
    
//MARK: - DataMethod
    
    private func setUploadImage() {
        
        var completionCount = 0 //for문이 끝나는 시점을 알기 위해서.
        var saveUrlArray : [String] = []  //image url들을 담는 공간
        var fileTitleArray : [String] = [] //image file의 제목
        
        self.indicatorView.startAnimating()
        
        print(photoImageArray)
        
        for image in photoImageArray {
            
            let titleDate = Date().timeIntervalSince1970
            
            var data = Data()
            data = image.jpegData(compressionQuality: 0.7)!
            
            let filePath = "saveImage\(titleDate)"
            let storageRefChild = self.storage.reference().child(filePath)
            
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            
            storageRefChild.putData(data, metadata: metaData) { (metadata, error) in
                if let e = error{
                    print("Error saved image : \(e)")
                }else{
                    storageRefChild.downloadURL { url, error in
                        if let e = error{
                            print("Error downloadURL : \(e)")
                        }else{
                            guard let urlString = url?.absoluteString else{return}
                            
                            saveUrlArray.append(urlString)
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
    
        let date = Date()
        let savedDate = DateFormatter()
        savedDate.dateFormat = "yyyy-MM-dd HH:mm"
        let convertDate = savedDate.string(from: date) //date형식 원하는 형태로 format
        
        if let user = Auth.auth().currentUser{
            db.collection("Users").document(user.uid).getDocument { querySnapshot, error in
                if let e = error{
                    print("Error find user nickname : \(e)")
                }else{
                    guard let userData = querySnapshot?.data() else {return}
                    
                    if let userNickName = userData["NickName"] as? String{
                        self.db.collection("전체보기").addDocument(data: ["Title" : self.titleText,
                                                                      "ingredients" : self.ingredientText,
                                                                      "segment" : self.seguementText,
                                                                      "tema" : self.temaText,
                                                                      "contents" : self.contentsText,
                                                                      "user" : user.uid,
                                                                      "date" : convertDate,
                                                                      "userNickName" : userNickName,
                                                                      "url" : FieldValue.arrayUnion(url),
                                                                      "imageFile" : FieldValue.arrayUnion(imageFileTitle)])
                        self.sendNotification()
                        self.initializationText()
                        self.tabBarController?.selectedIndex = 0
                        self.indicatorView.stopAnimating()
                    }
                }
            }
        }
    } //data 저장을 위한 method
    
    private func dataError(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }//오류에 관한 alert
    
    private func saveData() {
        let alert = UIAlertController(title: "게시", message: "저장이 완료되면 홈으로 이동합니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
       
        let saveAction = UIAlertAction(title: "저장", style: .default) { action in
            self.setUploadImage()
    
        }
        
        saveAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func initializationText() { //data를 저장한 후에는 모든 텍스트, 사진 초기화
        titleTextField.text = ""
        ingredientsTextView.text = ""
        pickerField.text = ""
        contentTextView.text = ""
        photoImageArray = []
        photoCollectionView.reloadData()
    }
    
 

}
//MARK: - Extension
extension SaveCreatedDataViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewHolder
            textView.textColor = .lightGray
        }
    }
}

extension SaveCreatedDataViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }//백스페이스는 감지할 수 있도록 하는 코드
        
        guard let text = textField.text else {return false}
        
        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
        if text.count > 9 {
            return false
        }
        
        return true
    }
}


extension SaveCreatedDataViewController : PHPickerViewControllerDelegate {
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self){
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self](image, error) in
                    
                    DispatchQueue.main.async {
                        guard let image = image as? UIImage else{return}
                        self?.photoImageArray.append(image)
                        self?.photoCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension SaveCreatedDataViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        cell.contentView.isUserInteractionEnabled = false
        cell.imageView.image = self.photoImageArray[indexPath.row]
        print(photoImageArray[indexPath.row])
        cell.imageView.tintColor = .customPink
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
}

extension SaveCreatedDataViewController : UICollectionViewDelegate {
    
}
extension SaveCreatedDataViewController : UICollectionViewDelegateFlowLayout {
    
    //옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 100, height: 100)
        
        return size
       }
    
}

extension SaveCreatedDataViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titlePickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

         return titlePickerArray[row]
     }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerField.text = titlePickerArray[row]
    }
}
