//
//  UIColorExtension.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/13.
//

import UIKit


extension UIColor {
    
    class var customGray: UIColor? { return UIColor(named: "회색") }
    class var customPink: UIColor? { return UIColor(named: "핑크") }
    class var customPink2: UIColor? { return UIColor(named: "진핑크") }
    class var customSignature: UIColor? { return UIColor(named: "signatureColor") }
    
}

extension UIButton {
    
    func setUnderLine() {
        guard let title = title(for: .normal) else{return}
        
        let attributed = NSMutableAttributedString(string: title)
        attributed.addAttribute(.underlineStyle,
                                value: NSUnderlineStyle.single.rawValue,
                                range: NSRange(location: 0, length: title.count))
        
        setAttributedTitle(attributed, for: .normal)
    }
    
    
}

