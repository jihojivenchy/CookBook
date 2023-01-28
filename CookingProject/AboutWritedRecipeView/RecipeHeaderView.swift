//
//  RecipeHeaderView.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/28.
//

import UIKit
import SnapKit

final class RecipeHeaderView: UIView {
    
    static let identifier = "RecipeHeader"
    
    final var delegate : PhotoHeaderTouchDelegate?
    final var buttonDelegate : PhotoDeleteButtonDelegate?
    
    private let stackView = UIStackView()
    private let progressBar = UIProgressView()
    private let introduceLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let photoCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = .init(width: 100, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        cv.clipsToBounds = true
        cv.layer.cornerRadius = 7
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    final var photoImageArray : [UIImage] = []
    
    final var sendedArray : [String] = ["", "", "", ""] {
        didSet{
            setStackView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        photoCollectionView.register(PhotoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoHeaderCollectionReusableView.identifier)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        self.addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(20)
        }
        
        self.addSubview(progressBar)
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
        
        self.addSubview(introduceLabel)
        introduceLabel.text = "사진과 조리과정을 작성해주세요."
        introduceLabel.textColor = .black
        introduceLabel.textAlignment = .center
        introduceLabel.font = UIFont(name: KeyWord.CustomFont, size: 25)
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        self.addSubview(subTitleLabel)
        subTitleLabel.text = "추가한 사진갯수와 동일하게 양식이 생성됩니다."
        subTitleLabel.textColor = .darkGray
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont(name: KeyWord.CustomFont, size: 17)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        self.addSubview(photoCollectionView)
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
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
    }
    
    
}

extension RecipeHeaderView : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
        cell.contentView.isUserInteractionEnabled = false
        cell.imageView.image = self.photoImageArray[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        
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

extension RecipeHeaderView : UICollectionViewDelegate {
    
}

extension RecipeHeaderView : PhotoHeaderTouchDelegate {
    func tapHeaderView() {
        self.delegate?.tapHeaderView()
    }
}

extension RecipeHeaderView : PhotoDeleteButtonDelegate {
    func delete(index: Int) {
        self.buttonDelegate?.delete(index: index)
    }
}

