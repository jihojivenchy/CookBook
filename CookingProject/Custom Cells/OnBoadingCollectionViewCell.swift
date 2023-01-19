//
//  OnBoadingCollectionViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/22.
//

import UIKit
import SnapKit

class OnBoadingCollectionViewCell: UICollectionViewCell {
    static let identifier = "onBoadingCollectionCell"
    
    let onBoadingImageView = UIImageView()
    let onBoadingLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        self.backgroundColor = .white
        
        addSubview(onBoadingImageView)
        onBoadingImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }
    }
}
