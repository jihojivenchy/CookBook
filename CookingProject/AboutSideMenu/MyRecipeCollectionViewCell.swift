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
    final let stackView = UIStackView()
    
    final let firstStackView = UIStackView()
    final let foodCategoryImageView = UIImageView()
    final let foodCategoryLabel = UILabel()
    
    final let secondStackView = UIStackView()
    final let heartImageView = UIImageView()
    final let heartCountLabel = UILabel()
    
    final let thirdStackView = UIStackView()
    final let commentImageView = UIImageView()
    final let commentCountLabel = UILabel()
    
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
        foodNameLable.textAlignment = .center
        foodNameLable.font = UIFont(name: FontKeyWord.CustomFont, size: 18)
        foodNameLable.snp.makeConstraints { make in
            make.top.equalTo(foodImageView.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(25)
        }

        backGroundView.addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.snp.makeConstraints { make in
            make.top.equalTo(foodNameLable.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        
        foodCategoryImageView.image = UIImage(systemName: "bookmark.fill")
        foodCategoryImageView.tintColor = .customSignature
        foodCategoryImageView.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
        foodCategoryLabel.textColor = .customSignature
        foodCategoryLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        
        firstStackView.backgroundColor = .clear
        firstStackView.axis = .vertical
        firstStackView.distribution = .fill
        firstStackView.alignment = .center
        firstStackView.spacing = 5
        firstStackView.addArrangedSubview(foodCategoryImageView)
        firstStackView.addArrangedSubview(foodCategoryLabel)
        
        
        heartImageView.image = UIImage(systemName: "suit.heart.fill")
        heartImageView.tintColor = .customSignature
        heartImageView.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
        heartCountLabel.textColor = .customSignature
        heartCountLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        
        secondStackView.backgroundColor = .clear
        secondStackView.axis = .vertical
        secondStackView.distribution = .fill
        secondStackView.alignment = .center
        secondStackView.spacing = 5
        secondStackView.addArrangedSubview(heartImageView)
        secondStackView.addArrangedSubview(heartCountLabel)
        
        commentImageView.image = UIImage(systemName: "doc.text.fill")
        commentImageView.tintColor = .customSignature
        commentImageView.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
        commentCountLabel.textColor = .customSignature
        commentCountLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        
        thirdStackView.backgroundColor = .clear
        thirdStackView.axis = .vertical
        thirdStackView.distribution = .fill
        thirdStackView.alignment = .center
        thirdStackView.spacing = 5
        thirdStackView.addArrangedSubview(commentImageView)
        thirdStackView.addArrangedSubview(commentCountLabel)
        
        
        stackView.addArrangedSubview(firstStackView)
        stackView.addArrangedSubview(secondStackView)
        stackView.addArrangedSubview(thirdStackView)
        
        backGroundView.addSubview(dateLabel)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .gray
        dateLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp_bottomMargin).offset(12)
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
