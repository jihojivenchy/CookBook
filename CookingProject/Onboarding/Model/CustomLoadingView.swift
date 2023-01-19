////
////  CustomLoadingView.swift
////  CookingProject
////
////  Created by 엄지호 on 2023/01/17.
////
//
//import UIKit
//import SnapKit
//import Lottie
//
//class CustomLoadingView {
//
//    private static let shared = CustomLoadingView()
//
//    private var backgroundView: UIView?
//    private var popupView: GIFImageView?
//
//    class func show() {
//        let backgroundView = UIView()
//        let popupView = GIFImageView()
//
//        if let window = UIApplication.shared.keyWindow {
//            window.addSubview(backgroundView)
//            window.addSubview(popupView)
//
//            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
//            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
//
//            popupView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            popupView.translatesAutoresizingMaskIntoConstraints = false
//            popupView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
//            popupView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
//            popupView.animate(withGIFNamed: "dualball")
//
//            shared.backgroundView?.removeFromSuperview()
//            shared.popupView?.removeFromSuperview()
//            shared.backgroundView = backgroundView
//            shared.popupView = popupView
//        }
//    }
//
//    class func hide() {
//        if let popupView = shared.popupView, let backgroundView = shared.backgroundView {
//            popupView.stopAnimatingGIF()
//            backgroundView.removeFromSuperview()
//            popupView.removeFromSuperview()
//        }
//    }
//}
//
//}
