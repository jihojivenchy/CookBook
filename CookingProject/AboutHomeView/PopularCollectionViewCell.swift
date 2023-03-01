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
    final let foodNameLabel = UILabel()
    final let explainStackView = UIStackView()
    
    final let firstStackView = UIStackView()
    final let heartImageView = UIImageView()
    final let heartCountLabel = UILabel()
    
    final let secondStackView = UIStackView()
    final let foodLevelImageView = UIImageView()
    final let foodLevelLabel = UILabel()
    
    final let thirdStackView = UIStackView()
    final let foodTimeImageView = UIImageView()
    final let foodTimeLabel = UILabel()
    
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
        foodImageView.backgroundColor = .white
        foodImageView.clipsToBounds = true
        foodImageView.layer.cornerRadius = 8
        foodImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(55)
        }
        
        addSubview(explainView)
        explainView.backgroundColor = .white
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
            make.height.equalTo(85)
        }
        
        explainView.addSubview(foodNameLabel)
        foodNameLabel.textColor = .customNavy
        foodNameLabel.textAlignment = .center
        foodNameLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 17)
        foodNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        explainView.addSubview(explainStackView)
        explainStackView.backgroundColor = .clear
        explainStackView.axis = .horizontal
        explainStackView.distribution = .fillEqually
        explainStackView.alignment = .center
        explainStackView.spacing = 0
        explainStackView.snp.makeConstraints { make in
            make.top.equalTo(foodNameLabel.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        heartImageView.image = UIImage(systemName: "suit.heart.fill")
        heartImageView.tintColor = .customSignature
        heartImageView.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
        heartCountLabel.textColor = .customSignature
        heartCountLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        
        firstStackView.backgroundColor = .clear
        firstStackView.axis = .vertical
        firstStackView.distribution = .fill
        firstStackView.alignment = .center
        firstStackView.spacing = 5
        firstStackView.addArrangedSubview(heartImageView)
        firstStackView.addArrangedSubview(heartCountLabel)
        
        
        foodLevelImageView.image = UIImage(systemName: "chart.bar.fill")
        foodLevelImageView.tintColor = .customSignature
        foodLevelImageView.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
        foodLevelLabel.textColor = .customSignature
        foodLevelLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        
        secondStackView.backgroundColor = .clear
        secondStackView.axis = .vertical
        secondStackView.distribution = .fill
        secondStackView.alignment = .center
        secondStackView.spacing = 5
        secondStackView.addArrangedSubview(foodLevelImageView)
        secondStackView.addArrangedSubview(foodLevelLabel)
        
        foodTimeImageView.image = UIImage(systemName: "alarm.fill")
        foodTimeImageView.tintColor = .customSignature
        foodTimeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
        foodTimeLabel.textColor = .customSignature
        foodTimeLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        
        thirdStackView.backgroundColor = .clear
        thirdStackView.axis = .vertical
        thirdStackView.distribution = .fill
        thirdStackView.alignment = .center
        thirdStackView.spacing = 5
        thirdStackView.addArrangedSubview(foodTimeImageView)
        thirdStackView.addArrangedSubview(foodTimeLabel)
        
        
        explainStackView.addArrangedSubview(firstStackView)
        explainStackView.addArrangedSubview(secondStackView)
        explainStackView.addArrangedSubview(thirdStackView)
    }
}
