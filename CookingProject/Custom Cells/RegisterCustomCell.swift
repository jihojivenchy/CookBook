//
//  RegisterCellTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/22.
//

import UIKit
import SnapKit


class RegisterCustomCell: UITableViewCell {
    
    let stpLabel = UILabel()
    let stpImage = UIImageView()
    let stpTextView = UITextView()
    
    static let cellIdentifier = "CustomTextviewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        
        addSubview(stpLabel)
        stpLabel.font = .systemFont(ofSize: 16)
        stpLabel.text = "Step"
        stpLabel.textColor = .black
        stpLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(50)
            make.height.equalTo(25)
        }
        
        addSubview(stpImage)
        stpImage.layer.borderColor = UIColor.customPink?.cgColor
        stpImage.layer.borderWidth = 1
        stpImage.backgroundColor = .white
        stpImage.snp.makeConstraints { make in
            make.top.equalTo(stpLabel.snp_bottomMargin).offset(15)
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(180)
            make.width.equalTo(150)
        }
        
        addSubview(stpTextView)
        stpTextView.backgroundColor = .white
        stpTextView.layer.masksToBounds = true
        stpTextView.layer.cornerRadius = 10
        stpTextView.layer.borderWidth = 1
        stpTextView.layer.borderColor = UIColor.customGray?.cgColor
        stpTextView.font = .systemFont(ofSize: 20, weight: .black)
        stpTextView.textColor = .black
        stpTextView.snp.makeConstraints { make in
            make.top.equalTo(stpLabel.snp_bottomMargin).offset(15)
            make.left.equalTo(stpImage.snp_rightMargin).offset(15)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(180)
            
        }
        
    }
}
