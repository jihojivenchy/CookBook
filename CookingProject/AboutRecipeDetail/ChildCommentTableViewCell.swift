//
//  InCommentTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/15.
//

import UIKit
import SnapKit

final class ChildCommentTableViewCell: UITableViewCell {
    static let identifier = "ChildCommentsCell"
    
    final var ChildCommentDelegate : ChildCommentMenuDelegate?
    final var section = Int()
    final var index = Int()
    
    final let ChildCommentImageView = UIImageView()
    final let personImageView = UIImageView()
    final let userNameLabel = UILabel()
    final let commentLabel = UILabel()
    final let dateLabel = UILabel()
    
    private lazy var menuButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .default)
        let image = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = .customNavy
        button.addTarget(self, action: #selector(menuButtonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(ChildCommentImageView)
        ChildCommentImageView.image = UIImage(systemName: "arrow.turn.down.right")
        ChildCommentImageView.tintColor = .customNavy
        ChildCommentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(15)
        }
        
        addSubview(personImageView)
        personImageView.image = UIImage(systemName: "person.circle")
        personImageView.tintColor = .customNavy
        personImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().offset(40)
            make.width.height.equalTo(27)
        }
        
        addSubview(userNameLabel)
        userNameLabel.textColor = .customNavy
        userNameLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 15)
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(personImageView)
            make.left.equalTo(personImageView.snp_rightMargin).offset(15)
            make.right.equalToSuperview().offset(40)
            make.height.equalTo(20)
        }
        
        addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
        
        
        addSubview(commentLabel)
        commentLabel.numberOfLines = 0
        commentLabel.textColor = .customNavy
        commentLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 19)
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp_bottomMargin).offset(20)
            make.left.equalTo(personImageView.snp_rightMargin).offset(15)
            make.right.equalToSuperview().inset(15)
        }
        
        addSubview(dateLabel)
        dateLabel.textColor = .darkGray
        dateLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp_bottomMargin).offset(15)
            make.left.equalTo(personImageView.snp_rightMargin).offset(15)
            make.right.equalToSuperview().offset(15)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().inset(15)
        }
        
    }
    
    @objc private func menuButtonPressed(_ sender : UIButton) {
        self.ChildCommentDelegate?.ChildCommentMenuClicked(section: self.section, index: self.index)
    }

}

protocol ChildCommentMenuDelegate {
    func ChildCommentMenuClicked(section : Int, index : Int)
}

