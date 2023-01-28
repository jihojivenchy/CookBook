//
//  CustomAlert.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/22.
//

import UIKit
import SCLAlertView

struct CustomAlert {
    
    static func show(title : String, subMessage : String) {
        let appearence = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: KeyWord.CustomFontMedium, size: 17) ?? .boldSystemFont(ofSize: 17), kTextFont: UIFont(name: KeyWord.CustomFont, size: 13) ?? .boldSystemFont(ofSize: 13), showCloseButton: false)
        let alert = SCLAlertView(appearance: appearence)
        
        
        alert.addButton("확인", backgroundColor: .customSignature, textColor: .white) {
            print("확인")
        }
        
        alert.showSuccess(title,
                          subTitle: subMessage,
                          colorStyle: 0xFFB6B9,
                          colorTextButton: 0xFFFFFF)
        
    }
    
    
    
}
