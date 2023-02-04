//
//  ShowRecipeCollectionViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/01.
//

import UIKit
import SnapKit

final class ShowRecipeCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShowCategoryCell"
    
    final let backGroundView = UIView()
    final let categoryImageView = UIImageView()
    final let categoryLabel = UILabel()
    
    final var index = Int()
    
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
            make.edges.equalToSuperview().inset(10)
        }
        
        backGroundView.addSubview(categoryImageView)
        categoryImageView.backgroundColor = .clear
        categoryImageView.clipsToBounds = true
        categoryImageView.layer.cornerRadius = 7
        categoryImageView.layer.masksToBounds = false
        categoryImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        backGroundView.addSubview(categoryLabel)
        categoryLabel.textColor = .customNavy
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont(name: KeyWord.CustomFont, size: 17)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryImageView.snp_bottomMargin).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
}
