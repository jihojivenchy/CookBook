//
//  WritePhotoCollectionViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/10.
//

import UIKit
import SnapKit

class WritePhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "writePhotoCollectionCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        self.backgroundColor = .white
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        
    }
    
}
