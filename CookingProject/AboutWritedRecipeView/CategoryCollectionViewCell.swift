//
//  CategoryCollectionViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/27.
//

import UIKit
import SnapKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    
    final let backGroundView = UIView()
    final let categoryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
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
            make.edges.equalToSuperview().inset(10)
        }
        
        backGroundView.addSubview(categoryLabel)
        categoryLabel.textAlignment = .center
        categoryLabel.textColor = .black
        categoryLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 16)
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
    }
    
    override var isSelected : Bool {
        didSet{
            if isSelected {
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.backGroundView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    self.backGroundView.backgroundColor = .customSignature
                    self.categoryLabel.textColor = .white
                }, completion: { _ in
                    self.backGroundView.transform = .identity
                })
                
            }else{
                self.backGroundView.backgroundColor = .white
                self.categoryLabel.textColor = .black
            }
        }
    }
    
}
