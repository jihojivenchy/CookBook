//
//  DetailRecipeTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/09.
//

import UIKit
import SnapKit

final class DetailRecipeTableViewCell: UITableViewCell {
    static let identifier = "DetailRecipeCell"
    
    final let backGroundView = UIView()
    final let foodImageView = UIImageView()
    final let recipeTextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
        backGroundView.addSubview(foodImageView)
        foodImageView.backgroundColor = .clear
        foodImageView.clipsToBounds = true
        foodImageView.layer.cornerRadius = 7
        foodImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
            make.width.equalTo(130)
        }
        
        backGroundView.addSubview(recipeTextView)
        recipeTextView.showsVerticalScrollIndicator = false
        recipeTextView.isEditable = false
        recipeTextView.returnKeyType = .next
        recipeTextView.font = .systemFont(ofSize: 17)
        recipeTextView.textColor = .black
        recipeTextView.clipsToBounds = true
        recipeTextView.layer.cornerRadius = 7
        recipeTextView.backgroundColor = .white
        recipeTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalTo(foodImageView.snp_rightMargin).offset(20)
            make.right.equalToSuperview().inset(10)
        }
    }
}


