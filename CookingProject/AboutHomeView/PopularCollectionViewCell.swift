//
//  PopularCollectionViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/18.
//

import UIKit
import SnapKit

final class PopularCollectionViewCell: UICollectionViewCell {
    static let identifier = "popularCell"
    
    final let foodImageView = UIImageView()
    
    final let explainView = UIView()
    
    final let foodLabel = UILabel()
    
    final let personImageView = UIImageView()
    final let nameLabel = UILabel()
    
    final let heartImageView = UIImageView()
    final let heartCountLabel = UILabel()
    
    final let levelImageView = UIImageView()
    final let levelLabel = UILabel()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
    
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(foodImageView)
        foodImageView.backgroundColor = .brown
        foodImageView.clipsToBounds = true
        foodImageView.layer.cornerRadius = 8
        foodImageView.layer.masksToBounds = false
        foodImageView.layer.shadowOpacity = 1
        foodImageView.layer.shadowColor = UIColor.darkGray.cgColor
        foodImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        foodImageView.layer.shadowRadius = 2
        foodImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(35)
        }
        
        addSubview(explainView)
        explainView.backgroundColor = .customSignature
        explainView.clipsToBounds = true
        explainView.layer.cornerRadius = 7
        explainView.layer.masksToBounds = false
        explainView.layer.shadowOpacity = 1
        explainView.layer.shadowColor = UIColor.darkGray.cgColor
        explainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        explainView.layer.shadowRadius = 2
        explainView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(65)
        }
        
        explainView.addSubview(foodLabel)
        foodLabel.text = "해물감자수제비"
        foodLabel.textColor = .white
        foodLabel.textAlignment = .center
        foodLabel.font = .boldSystemFont(ofSize: 17) //ChosunCentennial
        foodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        explainView.addSubview(personImageView)
        personImageView.image = UIImage(systemName: "person.fill")
        personImageView.tintColor = .white
        personImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(13)
        }
        
        explainView.addSubview(nameLabel)
        nameLabel.text = "엄쉐프"
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 12) //ChosunCentennial
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(personImageView)
            make.left.equalTo(personImageView.snp_rightMargin).offset(10)
            make.width.equalTo(70)
            make.height.equalTo(13)
        }
        
        explainView.addSubview(heartImageView)
        heartImageView.image = UIImage(systemName: "suit.heart.fill")
        heartImageView.tintColor = .white
        heartImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(13)
        }
        
        explainView.addSubview(heartCountLabel)
        heartCountLabel.text = "3"
        heartCountLabel.textColor = .white
        heartCountLabel.font = .boldSystemFont(ofSize: 12) //ChosunCentennial
        heartCountLabel.sizeToFit()
        heartCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(heartImageView)
            make.left.equalTo(heartImageView.snp_rightMargin).offset(10)
        }
        
        explainView.addSubview(levelLabel)
        levelLabel.text = "중급"
        levelLabel.textColor = .white
        levelLabel.font = .boldSystemFont(ofSize: 12) //ChosunCentennial
        levelLabel.sizeToFit()
        levelLabel.snp.makeConstraints { make in
            make.centerY.equalTo(heartImageView)
            make.right.equalToSuperview().inset(20)
        }
        
        explainView.addSubview(levelImageView)
        levelImageView.image = UIImage(systemName: "chart.bar.fill")
        levelImageView.tintColor = .white
        levelImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(45)
            make.width.height.equalTo(13)
        }
        
    }
}
