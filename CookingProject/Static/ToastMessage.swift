//
//  ToastMessage.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/23.
//

import UIKit

final class ToastMessage {
    static let shared = ToastMessage()
    
    private init() {
        
    }
    
    final func showToast(message: String, durationTime : TimeInterval, delayTime : TimeInterval, width : CGFloat, view: UIView) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - (width / 2), y: view.frame.size.height-100,
                                               width: width, height: 40))
        toastLabel.backgroundColor = .customSignature
        toastLabel.textColor = UIColor.white
        toastLabel.font = .boldSystemFont(ofSize: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        view.addSubview(toastLabel)
        UIView.animate(withDuration: durationTime, delay: delayTime, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
