//
//  WritedRecipeViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/25.
//

import UIKit
import SnapKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import BSImagePicker
import Photos

final class WViewController: UIViewController {
    //MARK: - Properties
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    private var selectedPhAsset : [PHAsset] = []
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private lazy var nextButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "다음", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let stackView = UIStackView()
    private let progressBar = UIProgressView()
    private let introduceLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let scrollView = UIScrollView()
    
    private let photoCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = .init(width: 100, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        cv.clipsToBounds = true
        cv.layer.cornerRadius = 7
        
        
        return cv
    }()
    
    final var photoImageArray : [String] = ["한식", "중식", "양식", "일식"]
    final var sendedArray : [String] = ["", "", "", ""]
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        
        addSubViews()
        setStackView()
        
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        photoCollectionView.register(PhotoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoHeaderCollectionReusableView.identifier)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
    }
    
    //MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func addSubViews() {
        
        view.backgroundColor = .customGray
        
        view.addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(20)
        }
        
        view.addSubview(progressBar)
        progressBar.backgroundColor = .lightGray
        progressBar.progress = 0.75
        progressBar.progressTintColor = .customSignature
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp_bottomMargin).offset(5)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(7)
        }
        
        view.addSubview(introduceLabel)
        introduceLabel.text = "사진과 조리과정을 작성해주세요."
        introduceLabel.textColor = .black
        introduceLabel.textAlignment = .center
        introduceLabel.font = UIFont(name: KeyWord.CustomFont, size: 25)
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        view.addSubview(subTitleLabel)
        subTitleLabel.text = "추가한 사진갯수와 동일하게 양식이 생성됩니다."
        subTitleLabel.textColor = .darkGray
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont(name: KeyWord.CustomFont, size: 17)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(110)
        }
        
    }
    
    private func setStackView() {
        
        for i in sendedArray {
            
            let label = UILabel()
            label.text = i
            label.textAlignment = .center
            label.textColor = .black
            label.backgroundColor = .clear
            label.font = UIFont(name: KeyWord.CustomFont, size: 11)
            label.clipsToBounds = true
            label.layer.cornerRadius = 7
            
            self.stackView.addArrangedSubview(label)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
    }
    
//MARK: - ButtonMethod
   
    
//MARK: - DataMethod
    
               
}
//MARK: - Extension
extension WViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        cell.contentView.isUserInteractionEnabled = false
        cell.imageView.image = UIImage(named: self.photoImageArray[indexPath.row])
        
        
        if indexPath.row == 0 {
            cell.firstLabel.isHidden = false
            
        }else{
            cell.firstLabel.isHidden = true
        }
        
        
        return cell
    }
    
    //headerview
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PhotoHeaderCollectionReusableView.identifier, for: indexPath) as! PhotoHeaderCollectionReusableView
            
            headerView.imageCountLabel.text = "\(photoImageArray.count) / 10"
            headerView.delegate = self
            
            return headerView
        default:
            assert(false, "nothing")
        }
    
        return UICollectionReusableView()
    }
    
    //headerview size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 90, height: 90)
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 90, height: 90)
        
        
        return size
    }
    
}

extension WViewController : UICollectionViewDelegate {
    
}

extension WViewController : PhotoHeaderTouchDelegate {
    func tapHeaderView() {
        print("zz")
    }
}



