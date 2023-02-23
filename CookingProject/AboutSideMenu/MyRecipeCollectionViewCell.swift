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
    
    final var foodCategory = String() {
        didSet{
            addSubViews()
        }
    }
    final var heartCount = Int()
    final var commentCount = Int()
    
    private lazy var temaButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .regular, scale: .default)
        let image = UIImage(systemName: "bookmark.fill", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = foodCategory
        configuration.attributedTitle?.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .customSignature
        
        return button
    }()
    
    private lazy var heartButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .regular, scale: .default)
        let image = UIImage(systemName: "suit.heart.fill", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = "\(heartCount)개"
        configuration.attributedTitle?.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .customSignature
        
        return button
    }()
    
    private lazy var commentButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .regular, scale: .default)
        let image = UIImage(systemName: "doc.text", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = "\(commentCount)개"
        configuration.attributedTitle?.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .customSignature
        
        return button
    }()
    
    final let stackView = UIStackView()
    
    final let dateLabel = UILabel()
    
    final let deleteModeCheckBox = UIImageView()
    final var indexRow = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        stackView.addArrangedSubview(temaButton)
        stackView.addArrangedSubview(heartButton)
        stackView.addArrangedSubview(commentButton)
        
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
