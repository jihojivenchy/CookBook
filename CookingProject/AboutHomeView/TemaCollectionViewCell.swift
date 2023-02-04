//
//  TemaCollectionViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/19.
//

import UIKit
import SnapKit

final class TemaCollectionViewCell: UICollectionViewCell {
    static let identifier = "temaCell"
    
    final let temaButton = UIButton()
    final let temaLabel = UILabel()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
    
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(temaButton)
        temaButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        addSubview(temaLabel)
        temaLabel.textColor = .customNavy
        temaLabel.textAlignment = .center
        temaLabel.font = UIFont(name: KeyWord.CustomFont, size: 20)
        temaLabel.snp.makeConstraints { make in
            make.top.equalTo(temaButton.snp_bottomMargin).offset(13)
            make.centerX.equalTo(temaButton)
            make.height.equalTo(23)
        }
    }
}
