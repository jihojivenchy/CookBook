//
//  ComunicationHeader.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/22.
//

import UIKit

class ComunicationHeader: UIView {
    
    let label1 = UILabel()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        
        addSubview(label1)
        label1.text = ""
        label1.font = .systemFont(ofSize: 20)
        label1.textColor = .customPink
        label1.textAlignment = .center
        label1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.left.right.equalToSuperview().inset(40)
        }
    }

}
