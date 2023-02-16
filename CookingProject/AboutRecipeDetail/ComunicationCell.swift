//
//  ComunicationCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/22.
//

import UIKit

final class ComunicationCell: UITableViewCell {
    static let cellIdentifier = "CustomTextviewCell"

    let idLabel = UILabel()
    let idImage = UIImageView()
    let inputLabel = UILabel()
    let timeLable = UILabel()
    let userUidLabel = UILabel()
    let documentIdLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        
        addSubview(idImage)
//        idImage.layer.borderColor = UIColor.black.cgColor
//        idImage.layer.borderWidth = 1
//        idImage.layer.cornerRadius = 20
        idImage.clipsToBounds = true
        idImage.backgroundColor = .white
        idImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(15)
            make.height.width.equalTo(40)
            
        }
        
        addSubview(idLabel)
        idLabel.font = .systemFont(ofSize: 20)
        idLabel.textColor = .black
        idLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.left.equalTo(idImage.snp_rightMargin).offset(20)
            make.right.equalToSuperview().inset(30)
            make.height.equalTo(20)
        }
        
        
        
        addSubview(inputLabel)
        inputLabel.font = .systemFont(ofSize: 16)
        inputLabel.numberOfLines = 0
        inputLabel.lineBreakMode = .byCharWrapping
        inputLabel.textColor = .black
        inputLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp_bottomMargin).offset(15)
            make.left.equalTo(idImage.snp_rightMargin).offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }
        
        addSubview(timeLable)
        timeLable.font = .systemFont(ofSize: 10)
        timeLable.textColor = .black
        timeLable.text = "yyyy-MM-dd HH:mm"
        timeLable.textColor = .customPink
        timeLable.snp.makeConstraints { make in
            make.top.equalTo(inputLabel.snp_bottomMargin).offset(10)
            make.left.equalTo(idImage.snp_rightMargin).offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    
    }

}
