//
//  MyPageCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/17.
//

import UIKit
import SnapKit

//MARK: - CustomCellClass
class MyPageCell : UITableViewCell {
    
    static let cellID = "CustomTableCell"
    
    let labelImage = UIImageView()
    let cellLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        self.backgroundColor = .white
        addSubview(labelImage)
        labelImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        addSubview(cellLabel)
        cellLabel.textColor = .black
        cellLabel.font = UIFont(name: "EF_Diary", size: 17)
        cellLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(labelImage.snp_rightMargin).offset(15)
            make.right.equalToSuperview().offset(15)
            make.height.equalTo(30)
        }
        
    }
    
}
