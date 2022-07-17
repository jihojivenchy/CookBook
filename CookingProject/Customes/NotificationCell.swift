//
//  NotificationCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit


class NotificationCell : UITableViewCell{
    
    static let cellName = "NotificationTableCell"
    let labelImage = UIImageView()
    let cellLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        addSubview(labelImage)
        labelImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        addSubview(cellLabel)
        cellLabel.numberOfLines = 1
        cellLabel.lineBreakMode = .byTruncatingTail
        cellLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(labelImage.snp_rightMargin).offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        addSubview(timeLabel)
        timeLabel.text = "5분전"
        timeLabel.font = .systemFont(ofSize: 10)
        timeLabel.textColor = .lightGray
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(cellLabel.snp_bottomMargin).offset(5)
            make.left.equalTo(labelImage.snp_rightMargin).offset(20)
            make.right.equalToSuperview().offset(30)
            make.height.equalTo(20)
        }
        
    }
}
