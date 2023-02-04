//
//  SideMenuTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/22.
//

import UIKit
import SnapKit

final class SideMenuTableViewCell: UITableViewCell {
    
    static let identifier = "SideMenuCell"
    
    
    final let menuImageView = UIImageView()
    final let menuLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(menuImageView)
        menuImageView.tintColor = .customSignature
        menuImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(22)
        }
        
        addSubview(menuLabel)
        menuLabel.textColor = .customNavy
        menuLabel.font = UIFont(name: KeyWord.CustomFont, size: 15)
        menuLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(menuImageView.snp_rightMargin).offset(20)
            make.right.equalToSuperview().offset(30)
            make.height.equalTo(30)
        }
        
    }
    
}
