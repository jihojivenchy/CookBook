//
//  CustomCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit

//MARK: - CustomCellClass
class CustomCell : UICollectionViewCell {
    static let identifier = "CustomCollectionCell"
    
    let imageView = UIImageView()
    let titleLable = UILabel()
    let difficultyLabel = UILabel()
    let whoLabel = UILabel()
    let dateLabel = UILabel()
    let userUidLabel = UILabel()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
    
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        self.backgroundColor = .white
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(170)
            
        }
        
        addSubview(titleLable)
        titleLable.textColor = .black
        titleLable.font = UIFont(name: "EF_Diary", size: 20)
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }

        addSubview(difficultyLabel)
        difficultyLabel.textColor = .black
        difficultyLabel.font = UIFont(name: "EF_Diary", size: 15)
        difficultyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp_bottomMargin).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(30)

        }

        addSubview(whoLabel)
        whoLabel.textColor = .black
        whoLabel.font = UIFont(name: "EF_Diary", size: 15)
        whoLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyLabel.snp_bottomMargin).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        addSubview(dateLabel)
        dateLabel.text = "yyyy-MM-dd HH:mm"
        dateLabel.textColor = .customPink
        dateLabel.font = UIFont(name: "EF_Diary", size: 11)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(whoLabel.snp_bottomMargin).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
        
        
    }
    
    
    
}
    
