//
//  CommentsTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/13.
//

import UIKit
import SnapKit

final class CommentsTableViewCell: UITableViewCell {
    static let identifier = "CommentsCell"
    
    final var delegate : CommentMenuButtonDelegate?
    final var index = Int() //section
    
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
    
    private lazy var childCommentButton : UIButton = {
        let button = UIButton()
        button.setTitle("답글 달기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont(name: FontKeyWord.CustomFont, size: 13)
        button.addTarget(self, action: #selector(childCommentButtonPressed(_:)), for: .touchUpInside)
        
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
        
        addSubview(personImageView)
        personImageView.image = UIImage(systemName: "person.circle")
        personImageView.tintColor = .customNavy
        personImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().offset(15)
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
        dateLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 13)
        dateLabel.sizeToFit()
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp_bottomMargin).offset(15)
            make.left.equalTo(personImageView.snp_rightMargin).offset(15)
            make.bottom.equalToSuperview().inset(15)
        }
        
        addSubview(childCommentButton)
        childCommentButton.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp_bottomMargin).offset(15)
            make.left.equalTo(dateLabel.snp_rightMargin).offset(25)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
    @objc private func menuButtonPressed(_ sender : UIButton) {
        self.delegate?.menuButtonClicked(index: self.index)
    }
    
    @objc private func childCommentButtonPressed(_ sender : UIButton) {
        self.delegate?.childButtonClicked(index: self.index)
    }

}

protocol CommentMenuButtonDelegate {
    func menuButtonClicked(index : Int)
    func childButtonClicked(index : Int)
}
