//
//  BlockUserTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/17.
//

import UIKit
import SnapKit

class BlockUserTableViewCell: UITableViewCell {
    
    static let identifier = "BlockUserCell"
    
    let userNameLabel = UILabel()
    let userUidLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        addSubview(userNameLabel)
        userNameLabel.textColor = .black
        userNameLabel.font = UIFont(name: "EF_Diary", size: 20)
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }

}
