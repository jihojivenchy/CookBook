//
//  MyRecipeCollectionViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/07.
//

import UIKit
import SnapKit

final class MyRecipeCollectionViewCell: UICollectionViewCell {
    static let identifier = "myRecipeCell"
    
    final let backGroundView = UIView()
    
    final let foodImageView = UIImageView()
    final let foodNameLable = UILabel()
    
    final let categoryImageView = UIImageView()
    final let categoryLabel = UILabel()
    
    final let heartImageView = UIImageView()
    final let heartCountLabel = UILabel()
    
    final let dateLabel = UILabel()
    
    final let deleteModeCheckBox = UIImageView()
    final var indexRow = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(backGroundView)
        backGroundView.backgroundColor = .white
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 7
        backGroundView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(5)
        }
        
        backGroundView.addSubview(foodImageView)
        foodImageView.backgroundColor = .clear
        foodImageView.clipsToBounds = true
        foodImageView.layer.cornerRadius = 7
        foodImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(10)
            make.height.equalTo(150)
        }
        
        backGroundView.addSubview(foodNameLable)
        foodNameLable.textColor = .customNavy
        foodNameLable.font = UIFont(name: FontKeyWord.CustomFont, size: 18)
        foodNameLable.snp.makeConstraints { make in
            make.top.equalTo(foodImageView.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(25)
        }

        backGroundView.addSubview(categoryImageView)
        categoryImageView.image = UIImage(systemName: "bookmark.fill")
        categoryImageView.tintColor = .customSignature
        categoryImageView.snp.makeConstraints { make in
            make.top.equalTo(foodNameLable.snp_bottomMargin).offset(20)
            make.left.equalToSuperview().inset(10)
            make.width.height.equalTo(15)
        }
        
        backGroundView.addSubview(categoryLabel)
        categoryLabel.textColor = .customNavy
        categoryLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 14)
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(categoryImageView)
            make.left.equalTo(categoryImageView.snp_rightMargin).offset(12)
            make.width.equalTo(30)
            make.height.equalTo(15)
        }
        
        backGroundView.addSubview(heartImageView)
        heartImageView.image = UIImage(systemName: "suit.heart.fill")
        heartImageView.tintColor = .customSignature
        heartImageView.snp.makeConstraints { make in
            make.top.equalTo(foodNameLable.snp_bottomMargin).offset(20)
            make.left.equalTo(categoryLabel.snp_rightMargin).offset(30)
            make.width.height.equalTo(15)
        }
        
        backGroundView.addSubview(heartCountLabel)
        heartCountLabel.textColor = .customNavy
        heartCountLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 14)
        heartCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(heartImageView)
            make.left.equalTo(heartImageView.snp_rightMargin).offset(12)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        
        backGroundView.addSubview(dateLabel)
        dateLabel.textColor = .gray
        dateLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(heartImageView.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        
        backGroundView.addSubview(deleteModeCheckBox)
        deleteModeCheckBox.image = UIImage(systemName: "checkmark.circle")
        deleteModeCheckBox.tintColor = .customSignature
//        deleteModeCheckBox.backgroundColor = .white
//        deleteModeCheckBox.clipsToBounds = true
//        deleteModeCheckBox.layer.cornerRadius = 25
        deleteModeCheckBox.isHidden = true
        deleteModeCheckBox.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
}
