//
//  RegisterViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/13.
//

import UIKit
import SnapKit
import PhotosUI
import Firebase
import FirebaseFirestore


class ModifyingDataViewController: UIViewController {

//MARK: - Properties
    private let db = Firestore.firestore()

    private var titleText = ""
    private var ingredientText = ""
    private var seguementText = "초급"
    private var temaText = ""
    private var contentsText = ""
    private var savedDate = ""
    private var saveDocumentID = ""
    
    private let titleLabel = UILabel()
    private lazy var titleTextField : UITextField = {
        let tf = UITextField()
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
    private let scrollView = UIScrollView()
    
    private lazy var ingredientsTextView : UITextView = {
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
    
    private lazy var saveButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(clearButtonPressed(_:)))
        
        return button
    }()
    
    private lazy var photoButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .done, target: self, action: #selector(imageFindButtonPressed(_:)))
        return button
    }()
    
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
    
    private var photoImageArray : [UIImage] = []
    
    private let view1 = UIView()
    private let label1 = UILabel()
    private let photoLabel = UILabel()
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItems = [saveButton, photoButton]
        navigationTitleCustom()
        
        viewChange()
        createPicker()
        dismissPickerView()
        getSavedDataUpdate()
        
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
        titleName.text = "수정하기"
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
    
    private func createPicker() { //pickerview생성
        let temaPicker = UIPickerView()
        temaPicker.dataSource = self
        temaPicker.delegate = self
        pickerField.inputView = temaPicker
    }
    
    private func dismissPickerView() { //toolbar를 통해 나옴
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button1 = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(buttonPressed))
        toolBar.setItems([button1], animated: true)
        toolBar.isUserInteractionEnabled = true
        pickerField.inputAccessoryView = toolBar
    }
    
    @objc private func buttonPressed(_ sender: Any) {
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
    
    @objc private func deleteButtonPressed(_ sender : UIButton){ //collectionview photo delete method
        print("delete")
        photoCollectionView.deleteItems(at: [IndexPath.init(row: sender.tag, section: 0)])
        photoImageArray.remove(at: sender.tag)
        photoCollectionView.reloadData()
    }
    
@available(iOS 14, *)
    @objc private func imageFindButtonPressed(_ sender : UIBarButtonItem){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10 //선택할 수 있는 개수
        configuration.filter = .any(of: [.images]) //갤러리에서 가져올 때 제한할 종류
        let picker = PHPickerViewController(configuration : configuration)
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    
    }
    
//MARK: - DataMethod
    
    private func dataError(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }//오류에 관한 alert
    
    private func getSavedDataUpdate() {
        guard let savedDate = UserDefaults.standard.string(forKey: "selectedDate") else{return}
        
        if let savedTitle = UserDefaults.standard.string(forKey: "selectedTitle"){
            db.collection("전체보기").whereField("Title", isEqualTo: savedTitle).whereField("date", isEqualTo: savedDate).getDocuments { querySnapshot, error in
                if let e = error {
                    print("Error find data : \(e)")
                }else{
                    
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            self.saveDocumentID = doc.documentID //해당 도큐먼트 id 저장하기.
                            
                            if let titleData = data["Title"] as? String, let segmentData = data["segment"] as? String, let ingredientData = data["ingredients"] as? String, let temaData = data["tema"] as? String, let contentsData = data["contents"] as? String, let dateData = data["date"] as? String{
                                
                                self.segmentSavedData(segmentData: segmentData)
                                self.titleTextField.text = titleData
                                self.ingredientsTextView.text = ingredientData
                                self.pickerField.text = temaData
                                self.savedDate = dateData
                                self.contentTextView.text = contentsData
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func segmentSavedData(segmentData : String) {//저장된 세그먼트 데이터를 표현하기 위해
        
        if segmentData == "초급"{
            segmentButton.selectedSegmentIndex = 0
        }else if segmentData == "중급"{
            segmentButton.selectedSegmentIndex = 1
        }else {
            segmentButton.selectedSegmentIndex = 2
        }
    }
    
    private func setUploadModifyData() {
        
        if saveDocumentID == "" {
            print("Failed find documentId")
        }else{
            if let user = Auth.auth().currentUser{
                db.collection("전체보기").document(saveDocumentID).setData(["Title" : self.titleText,
                                                                        "ingredients" : self.ingredientText,
                                                                        "segment" : self.seguementText,
                                                                        "tema" : self.temaText,
                                                                        "contents" : contentsText,
                                                                        "user" : user.uid,
                                                                        "date" : savedDate])
                self.navigationController?.popViewController(animated: true)
            }
        }
    } //data 저장을 위한 method
    
    private func saveData() {
        let alert = UIAlertController(title: "수정", message: "저장을 누르면 수정된 글로 저장됩니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
       
        let saveAction = UIAlertAction(title: "저장", style: .default) { action in
            self.setUploadModifyData()
            
        }
        
        saveAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func clearButtonPressed(_ sender : UIButton){
        guard let title = titleTextField.text, let ingredient = ingredientsTextView.text, let tema = pickerField.text, let contents = contentTextView.text else {return print("Error text nil")}
        
        if title != "", ingredient != "", tema != "", contents != "" {
            self.titleText = title
            self.ingredientText = ingredient
            self.temaText = tema
            self.contentsText = contents
            
            self.saveData()
        }else{
            dataError(title: "작성오류", message: "모든 정보란에 정보를 기입해주세요")
        }
    }

}
//MARK: - Extension

extension ModifyingDataViewController : UITextFieldDelegate {
    
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


extension ModifyingDataViewController : PHPickerViewControllerDelegate {
    
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

extension ModifyingDataViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        cell.contentView.isUserInteractionEnabled = false
        cell.imageView.image = photoImageArray[indexPath.row]
        cell.imageView.tintColor = .customPink
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
}

extension ModifyingDataViewController : UICollectionViewDelegateFlowLayout {
    
    //옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 100, height: 100)
        
        return size
       }
    
}

extension ModifyingDataViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
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

