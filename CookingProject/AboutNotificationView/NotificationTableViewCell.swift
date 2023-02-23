//
//  NotificationCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit

final class NotificationTableViewCell : UITableViewCell{
    
    static let identifier = "NotificationTableCell"
    
    final let notiImageView = UIImageView()
    final let titleLabel = UILabel()
    final let subTitleLabel = UILabel()
    final let dateLabel = UILabel()
    
    final var indexRow = Int()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(notiImageView)
        notiImageView.tintColor = .customNavy
        notiImageView.image = UIImage(systemName: "megaphone")
        notiImageView.backgroundColor = .clear
        notiImageView.clipsToBounds = true
        notiImageView.layer.cornerRadius = 7
        notiImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(20)
        }
        
        addSubview(titleLabel)
        titleLabel.textColor = .customNavy
        titleLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 18)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(notiImageView)
            make.left.equalTo(notiImageView.snp_rightMargin).offset(25)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.textColor = .darkGray
        subTitleLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 17)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(7)
            make.left.equalTo(notiImageView.snp_rightMargin).offset(25)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        addSubview(dateLabel)
        dateLabel.textColor = .darkGray
        dateLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp_bottomMargin).offset(15)
            make.left.equalTo(notiImageView.snp_rightMargin).offset(25)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(15)
        }
        
    }
    
}
