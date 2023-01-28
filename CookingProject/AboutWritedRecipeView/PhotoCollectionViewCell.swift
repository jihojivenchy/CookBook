//
//  PhotoCollectionViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/08.
//

import UIKit
import SnapKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    
    final var delegate : PhotoDeleteButtonDelegate?
    
    final let imageView = UIImageView()
    final let deleteButton = UIButton()
    
    final let firstLabel = UILabel()
    
    final var index = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        imageView.addSubview(firstLabel)
        firstLabel.backgroundColor = .black
        firstLabel.text = "대표 사진"
        firstLabel.textAlignment = .center
        firstLabel.textColor = .white
        firstLabel.font = .boldSystemFont(ofSize: 12)
        firstLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        deleteButton.setBackgroundImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        deleteButton.tintColor = .black
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(25)
        }
    }
    
    @objc private func deleteButtonPressed(_ sender : UIButton) {
        self.delegate?.delete(index: self.index)
    }
}

protocol PhotoDeleteButtonDelegate {
    func delete(index : Int)
}
