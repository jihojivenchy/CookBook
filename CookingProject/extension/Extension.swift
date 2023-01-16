//
//  UIColorExtension.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/13.
//

import UIKit

//enum CustomColor {
//    case green_5b
//    case subGray
//}

extension UIColor {
    
    class var customGreen: UIColor? { return UIColor(named: "초록") }
    class var customGreen2: UIColor? { return UIColor(named: "맑은연두") }
    class var customGray: UIColor? { return UIColor(named: "회색") }
    class var customPink: UIColor? { return UIColor(named: "핑크") }
    class var customPink2: UIColor? { return UIColor(named: "진핑크") }
    
//    static func hexStringToUIColor (hex:String) -> UIColor {
//            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//            if (cString.hasPrefix("#")) {
//                cString.remove(at: cString.startIndex)
//            }
//
//            if ((cString.count) != 6) {
//                return UIColor.gray
//            }
//
//            var rgbValue:UInt64 = 0
//            Scanner(string: cString).scanHexInt64(&rgbValue)
//
//            return UIColor(
//                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//                alpha: CGFloat(1.0)
//            )
//        }
//
//    static func customColor(_ id: CustomColor) -> UIColor {
//        switch id {
//        case .green_5b:
//            return UIColor.hexStringToUIColor(hex: "#94B49F")
//        case .subGray:
//            return UIColor.hexStringToUIColor(hex: "#E6E3E3")
//        default :
//            assert(false, "No")
//
//
//
//        }
//
//    }
    
}

