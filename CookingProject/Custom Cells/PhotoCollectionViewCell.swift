//
//  PhotoCollectionViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/08.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionCell"
    
    let imageView = UIImageView()
    let deleteButton = UIButton()
    
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
            make.top.bottom.left.right.equalToSuperview().inset(9)
        }
        
        addSubview(deleteButton)
        deleteButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        deleteButton.tintColor = .customPink
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }

}
