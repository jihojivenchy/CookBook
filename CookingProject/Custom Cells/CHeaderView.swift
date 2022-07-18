//
//  CollectionHeaderView.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit


class CHeaderView : UICollectionReusableView {
    
    static let headerIdenty = "CustomHeader"
    
    let lineView = UIView()
    let idLabel = UILabel()
    let nickNameLabel = UILabel()
    let pImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewInit() {
        
        addSubview(pImage)
        pImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(30)
            make.width.height.equalTo(50)
        }
        
        addSubview(nickNameLabel)
        nickNameLabel.font = .systemFont(ofSize: 25)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        addSubview(idLabel)
        idLabel.font = .systemFont(ofSize: 14)
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp_bottomMargin).offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
    }
}
