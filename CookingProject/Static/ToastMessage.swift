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
    
    final func showToast(message: String, view: UIView) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 100, y: view.frame.size.height-100, width: 200, height: 40))
        toastLabel.backgroundColor = .customSignature?.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .boldSystemFont(ofSize: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
