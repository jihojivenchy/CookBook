//
//  CustomCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit

//MARK: - CustomCellClass
class CustomCell : UICollectionViewCell {
    static let identifier = "CustomCollectionCell"
    
    let imageView = UIImageView()
    let titleLable = UILabel()
    let difficultyLabel = UILabel()
    let whoLabel = UILabel()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
    
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(140)
            
        }
        
        addSubview(titleLable)
        titleLable.text = "우리의 음식"
        titleLable.textColor = .black
        titleLable.font = .systemFont(ofSize: 20)
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }

        addSubview(difficultyLabel)
        difficultyLabel.text = "초급"
        difficultyLabel.textColor = .black
        difficultyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp_bottomMargin).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(20)

        }

        addSubview(whoLabel)
        whoLabel.text = "작성자 : jiho"
        whoLabel.textColor = .black
        whoLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyLabel.snp_bottomMargin).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
        
        
        
        
    }
    
    
    
}
    
