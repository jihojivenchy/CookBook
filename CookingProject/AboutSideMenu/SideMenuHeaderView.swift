//
//  MyPageHeaderView.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit

//MARK: = CustomHeaderView
final class SideMenuHeaderView : UIView {
    
    final var delegate : SideMenuHeaderTouchDelegate?
    
    static let identifier = "SideMenuHeader"
    
    final let userImageView = UIImageView()
    final let nameLabel = UILabel()
    final let emailLabel = UILabel()
    final let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addSubViews() {

        self.backgroundColor = .customSignature
        
        addSubview(userImageView)
        userImageView.tintColor = .white
        userImageView.image = UIImage(systemName: "person.circle")
        userImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(45)
        }
        
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: KeyWord.CustomFont, size: 18)
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        
        emailLabel.textColor = .white
        emailLabel.font = UIFont(name: KeyWord.CustomFont, size: 13)
        emailLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(emailLabel)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(userImageView.snp_rightMargin).offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.delegate?.tapHeaderView()
    }
    
    
}

protocol SideMenuHeaderTouchDelegate {
    func tapHeaderView()
}
