//
//  CategoryTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/26.
//

import UIKit
import SnapKit

final class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "CategorycCell"
    
    private let backGroundView = UIView()
    final let categoryLabel = UILabel()
    
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
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(7)
        }
        
        backGroundView.addSubview(categoryLabel)
        categoryLabel.textColor = .black
        categoryLabel.font = .boldSystemFont(ofSize: 15)
        categoryLabel.sizeToFit()
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
    }
    
}
