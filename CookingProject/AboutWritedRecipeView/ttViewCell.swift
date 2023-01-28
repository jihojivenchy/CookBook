//
//  RecipeTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/26.
//

import UIKit
import SnapKit

final class ttViewCell: UITableViewCell {
    static let identifier = "RecipesCell"
    
    final let photoCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.itemSize = .init(width: 100, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        cv.clipsToBounds = true
        
        
        return cv
    }()
    
    final var photoImageArray : [String] = ["비빔밥"]
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        photoCollectionView.register(PhotoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoHeaderCollectionReusableView.identifier)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ttViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        
        return CGSize(width: 100, height: 100)
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 90, height: 90)
        
        
        return size
    }
    
}

extension ttViewCell : UICollectionViewDelegate {
    
}



extension ttViewCell : PhotoHeaderTouchDelegate {
    func tapHeaderView() {
        print("zz")
    }
}

