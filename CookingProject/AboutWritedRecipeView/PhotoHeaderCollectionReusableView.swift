//
//  PhotoHeaderCollectionReusableView.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/25.
//

import UIKit
import SnapKit

final class PhotoHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PhotoHeaderView"
    
    final var delegate : PhotoHeaderTouchDelegate?
    
    private let backGroundView = UIView()
    private let photoImageview = UIImageView()
    final let imageCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        backGroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
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
        backGroundView.layer.borderWidth = 1
        backGroundView.layer.borderColor = UIColor.darkGray.cgColor
        backGroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        
        backGroundView.addSubview(photoImageview)
        photoImageview.image = UIImage(systemName: "camera.fill")
        photoImageview.backgroundColor = .white
        photoImageview.tintColor = .black
        photoImageview.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(25)
        }
        
        backGroundView.addSubview(imageCountLabel)
        imageCountLabel.backgroundColor = .clear
        imageCountLabel.textAlignment = .center
        imageCountLabel.textColor = .black
        imageCountLabel.font = .boldSystemFont(ofSize: 11)
        imageCountLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(15)
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.delegate?.tapHeaderView()
    }
    
}

protocol PhotoHeaderTouchDelegate {
    func tapHeaderView()
}
