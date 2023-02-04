//
//  ShowRecipeTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/01.
//

import UIKit
import SnapKit

final class ShowRecipeTableViewCell: UITableViewCell {
    
    static let identifier = "ShowRecipeCell"
    final var tapDelegate : RecipeCellDoublTabDelegate?
    
    final let backGroundView = UIView()
    final let foodImageView = UIImageView()
    final let foodNameLable = UILabel()
    final let personImageView = UIImageView()
    final let chefNameLabel = UILabel()
    
    final let levelImageView = UIImageView()
    final let foodLevelLabel = UILabel()
    
    final let heartImageView = UIImageView()
    final let heartCountLabel = UILabel()
    
    final let timeImageView = UIImageView()
    final let timeLabel = UILabel()
    
    final var indexRow = Int()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setDoublTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(backGroundView)
        backGroundView.backgroundColor = .white
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 7
        backGroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        backGroundView.addSubview(foodImageView)
        foodImageView.backgroundColor = .clear
        foodImageView.clipsToBounds = true
        foodImageView.layer.cornerRadius = 7
        foodImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(150)
        }
        
        backGroundView.addSubview(foodNameLable)
        foodNameLable.textColor = .customNavy
        foodNameLable.font = UIFont(name: KeyWord.CustomFont, size: 18)
        foodNameLable.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalTo(foodImageView.snp_rightMargin).offset(30)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(25)
        }

        backGroundView.addSubview(personImageView)
        personImageView.image = UIImage(systemName: "person.fill")
        personImageView.tintColor = .customSignature
        personImageView.snp.makeConstraints { make in
            make.top.equalTo(foodNameLable.snp_bottomMargin).offset(20)
            make.left.equalTo(foodImageView.snp_rightMargin).offset(30)
            make.width.height.equalTo(15)
        }
        
        backGroundView.addSubview(chefNameLabel)
        chefNameLabel.textColor = .customNavy
        chefNameLabel.font = UIFont(name: KeyWord.CustomFont, size: 14)
        chefNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(personImageView)
            make.left.equalTo(personImageView.snp_rightMargin).offset(15)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(15)
        }
        
        backGroundView.addSubview(heartImageView)
        heartImageView.image = UIImage(systemName: "suit.heart.fill")
        heartImageView.tintColor = .customSignature
        heartImageView.snp.makeConstraints { make in
            make.top.equalTo(personImageView.snp_bottomMargin).offset(20)
            make.left.equalTo(foodImageView.snp_rightMargin).offset(30)
            make.width.height.equalTo(15)
        }
        
        backGroundView.addSubview(heartCountLabel)
        heartCountLabel.textColor = .customNavy
        heartCountLabel.font = UIFont(name: KeyWord.CustomFont, size: 14)
        heartCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(heartImageView)
            make.left.equalTo(heartImageView.snp_rightMargin).offset(15)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(15)
        }

        
        backGroundView.addSubview(levelImageView)
        levelImageView.image = UIImage(systemName: "chart.bar.fill")
        levelImageView.tintColor = .customSignature
        levelImageView.snp.makeConstraints { make in
            make.top.equalTo(heartImageView.snp_bottomMargin).offset(20)
            make.left.equalTo(foodImageView.snp_rightMargin).offset(30)
            make.width.height.equalTo(15)
        }
        
        backGroundView.addSubview(foodLevelLabel)
        foodLevelLabel.textColor = .customNavy
        foodLevelLabel.font = UIFont(name: KeyWord.CustomFont, size: 14)
        foodLevelLabel.sizeToFit()
        foodLevelLabel.snp.makeConstraints { make in
            make.centerY.equalTo(levelImageView)
            make.left.equalTo(levelImageView.snp_rightMargin).offset(15)
        }
        
        backGroundView.addSubview(timeImageView)
        timeImageView.image = UIImage(systemName: "alarm.fill")
        timeImageView.tintColor = .customSignature
        timeImageView.snp.makeConstraints { make in
            make.top.equalTo(heartImageView.snp_bottomMargin).offset(20)
            make.left.equalTo(foodLevelLabel.snp_rightMargin).offset(30)
            make.width.height.equalTo(15)
        }
        
        backGroundView.addSubview(timeLabel)
        timeLabel.textColor = .customNavy
        timeLabel.font = UIFont(name: KeyWord.CustomFont, size: 14)
        timeLabel.sizeToFit()
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeImageView)
            make.left.equalTo(timeImageView.snp_rightMargin).offset(15)
        }
    }
    
    private func setDoublTapGesture() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGestureRecognizer)
        
    }
        
    @objc private func doubleTapped() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred() //진동효과
        
        tapDelegate?.doubleTab(index: self.indexRow)
    }
}

protocol RecipeCellDoublTabDelegate {
    func doubleTab(index : Int)
}
