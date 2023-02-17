//
//  UIColorExtension.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/13.
//

import UIKit


extension UIColor {
    
    class var customPink: UIColor? { return UIColor(named: "핑크") }
    class var customSignature: UIColor? { return UIColor(named: "signatureColor") } //signatureColor
    class var customPink2: UIColor? { return UIColor(named: "customPink") }
    class var customWhite: UIColor? { return UIColor(named: "customWhite") }
    class var customNavy: UIColor? { return UIColor(named: "customNavy") }
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

extension UITextField {
    func textFieldBorderCustom(target : UITextField) {
        
        let border = UIView()
        border.backgroundColor = .lightGray
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: target.frame.width, height: 2)
        
        target.addSubview(border)
        //특정 border line
    }
}
