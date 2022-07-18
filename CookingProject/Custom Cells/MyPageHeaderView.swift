//
//  MyPageHeaderView.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit

//MARK: = CustomHeaderView
class MyPageHeaderView : UIView {
    
    static let viewID = "CustomHeaderView"
    
    let imageView = UIImageView()
    let idLabel = UILabel()
    let nameLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func viewInit() {
        
        addSubview(imageView)
        imageView.tintColor = .white
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 60 / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "요리사")
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(60)
        }
        
        addSubview(nameLabel)
        nameLabel.text = "닉네임"
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(imageView.snp_rightMargin).offset(23)
            make.right.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
        
        
        addSubview(idLabel)
        idLabel.text = "ddasdadadsa@naver.com"
        idLabel.font = .systemFont(ofSize: 15)
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(10)
            make.left.equalTo(imageView.snp_rightMargin).offset(23)
            make.right.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }

       
    }
    
}


