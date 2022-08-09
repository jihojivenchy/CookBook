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

class ModifyViewController: UIViewController {
    
    //MARK: - Properties
    let db = Firestore.firestore()
    
    private let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    var titleText = ""
    var ingredientText = ""
    var seguementText = "초급"
    var temaText = ""
    
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
        tv.returnKeyType = .done
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.customGray?.cgColor
        tv.font = .systemFont(ofSize: 20, weight: .black)
        tv.textColor = .black
        tv.delegate = self
        tv.tag = 1
        
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
    
    private let temaLabel = UILabel()
    private lazy var pickerField : UITextField = {
        let pf = UITextField()
        pf.backgroundColor = .white
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
    
    private let contentsLabel = UILabel()
    
    private lazy var saveButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(clearButtonPressed(_:)))
        return button
    }()
    
    private lazy var photoButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .done, target: self, action: #selector(imageFindButtonPressed(_:)))
        return button
    }()
    
    private lazy var contentTextView : UITextView = {
        let tv = UITextView()
        tv.returnKeyType = .done
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.customGray?.cgColor
        tv.font = .systemFont(ofSize: 20, weight: .black)
        tv.textColor = .black
        tv.delegate = self
        tv.tag = 2
        
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
    
    var photoImageArray : [UIImage] = []
    
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
        navigationItem.title = "수정"
        navigationItem.rightBarButtonItems = [saveButton, photoButton]
        
        viewChange()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))//개체들이 모두 스크롤뷰 위에 존재하기 때문에 스크롤뷰 특성 상 touchBegan함수가 실행되지 않는다. 따라서 스크롤뷰에 대한 핸들러 캐치를 등록해주어야 한다.
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
    }

//MARK: - ViewMethod
    private func viewChange() {
        
        view.backgroundColor = .white
        
        view.addSubview(photoCollectionView)
        photoCollectionView.layer.borderWidth = 1
        photoCollectionView.layer.borderColor = UIColor.customPink?.cgColor
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets).inset(10)
            make.left.right.equalTo(view)
            make.height.equalTo(185)
        }
        
        view.addSubview(scrollView)
        scrollView.indicatorStyle = .white
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp_bottomMargin).offset(10)
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
        
        scrollView.addSubview(ingredientsLabel)
        ingredientsLabel.text = "재료"
        ingredientsLabel.font = .systemFont(ofSize: 20)
        ingredientsLabel.textColor = .customPink2
        ingredientsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(20)
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
        
        scrollView.addSubview(seguementLabel)
        seguementLabel.text = "난이도"
        seguementLabel.font = .systemFont(ofSize: 20)
        seguementLabel.textColor = .customPink2
        seguementLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredientsTextView.snp_bottomMargin).offset(20)
            make.left.equalTo(view).inset(20)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(segmentButton)
        segmentButton.snp.makeConstraints { make in
            make.top.equalTo(ingredientsTextView.snp_bottomMargin).offset(20)
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
        
        scrollView.addSubview(contentsLabel)
        contentsLabel.text = "내용작성"
        contentsLabel.textAlignment = .center
        contentsLabel.textColor = .customPink2
        contentsLabel.font = .systemFont(ofSize: 20)
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerField.snp_bottomMargin).offset(30)
            make.centerX.equalTo(view)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentsLabel.snp_bottomMargin).offset(20)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(330)
            make.bottom.equalTo(scrollView).inset(20)
        }
        
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true) // todo...
        }
        sender.cancelsTouchesInView = false
    }//스크롤뷰 터치 시에 endEditing 발생
    
    //MARK: - Method
    
    func dataError(title : String, message : String) { 
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func clearButtonPressed(_ sender : UIButton){
        
    }
    
//MARK: - Method
    @objc private func deleteButtonPressed(_ sender : UIButton){
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

}
//MARK: - Extension
extension ModifyViewController : UITextViewDelegate{
    
}

extension ModifyViewController : UITextFieldDelegate {
    
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
        if text.count > 10 {
            return false
        }
        
        return true
    }
}


extension ModifyViewController : PHPickerViewControllerDelegate {
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
//        if results.isEmpty == false{
//            photoImageArray.removeAll()
//        }
//
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

extension ModifyViewController : UICollectionViewDataSource {
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

extension ModifyViewController : UICollectionViewDelegate {
    
}
extension ModifyViewController : UICollectionViewDelegateFlowLayout {
    
    //옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 95, height: 95)
        
        return size
       }
    
}
