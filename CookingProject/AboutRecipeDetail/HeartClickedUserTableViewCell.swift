//
//  HeartClickedUserTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/11.
//

import UIKit
import SnapKit

final class HeartClickedUserTableViewCell: UITableViewCell {
    
    static let identifier = "HeartUsersCell"
    
    final let backGroundView = UIView()
    final let personImageView = UIImageView()
    final let nameLabel = UILabel()
    
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
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 10
        backGroundView.backgroundColor = .white
        backGroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        backGroundView.addSubview(personImageView)
        personImageView.image = UIImage(systemName: "person.circle")
        personImageView.tintColor = .customNavy
        personImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(25)
        }
        
        backGroundView.addSubview(nameLabel)
        nameLabel.textColor = .customNavy
        nameLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 17)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(personImageView.snp_rightMargin).offset(15)
            make.right.equalToSuperview().offset(30)
            make.height.equalTo(30)
        }
        
    }
    
}
