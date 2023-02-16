//
//  MyRecipeHeaderCollectionReusableView.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/08.
//

import UIKit
import SnapKit

final class MyRecipeHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "myRecipeHeader"
    
    final var delegate : MyRecipeHeaderViewDelegate?
    final var sequenceString : String = String() {
        didSet{
            setSequenceButton(title: sequenceString)
        }
    }
    
    final let categoryLabel = UILabel()
    final let subTitleLabel = UILabel()
    
    final let stackView = UIStackView()
    final let countLabel = UILabel()
    final let sequenceButton = UIButton()
       
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(categoryLabel)
        categoryLabel.textColor = .customNavy
        categoryLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 27)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.textColor = .darkGray
        subTitleLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 17)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        addSubview(countLabel)
        countLabel.textColor = .customNavy
        countLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 17)
        countLabel.textAlignment = .center
        
        addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(sequenceButton)
        
    }
    
    private func setSequenceButton(title : String) {
        //button menu
        let latestAction = UIAction(title: "최신순", handler: { _ in self.delegate?.changeSequence(title: "최신순")})
        let oldAction = UIAction(title: "과거순", handler: { _ in self.delegate?.changeSequence(title: "과거순")})
        let popularAction = UIAction(title: "인기순", handler: { _ in self.delegate?.changeSequence(title: "인기순")})
        
        let menu = UIMenu(title: "정렬", identifier: nil, options: .displayInline, children: [latestAction, oldAction, popularAction])
        
        //button image
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .regular, scale: .default)
        let image = UIImage(systemName: "arrowtriangle.down.fill", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 5
        configuration.title = title
        configuration.attributedTitle?.font = UIFont(name: FontKeyWord.CustomFont, size: 16)
        configuration.baseBackgroundColor = .clear
        
        //set button
        sequenceButton.configuration = configuration
        sequenceButton.menu = menu
        sequenceButton.showsMenuAsPrimaryAction = true
        sequenceButton.tintColor = .customNavy
        sequenceButton.clipsToBounds = true
        sequenceButton.layer.cornerRadius = 7
        sequenceButton.sizeToFit()
    }
}

protocol MyRecipeHeaderViewDelegate{
    func changeSequence(title : String)
}
