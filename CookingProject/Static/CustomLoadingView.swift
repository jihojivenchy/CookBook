//
//  CustomLoadingView.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/21.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

final class CustomLoadingView {
    static let shared = CustomLoadingView()
    
    final let backgroundView = UIView()
    final let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50),
                                                          type: .ballRotateChase,
                                                          color: .customSignature,
                                                          padding: 0)
    
    private init() {
        
        // Add the activity indicator to the view
        let windowScene = UIApplication.shared.connectedScenes.first {$0.activationState == .foregroundActive} as? UIWindowScene
        windowScene?.windows.first?.addSubview(backgroundView)
        backgroundView.addSubview(activityIndicator)
//        windowScene?.windows.first?.addSubview(activityIndicator)
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 7
        backgroundView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(90)
        }
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        backgroundView.isHidden = true
    }
    
    final func startLoading() {
        // Start the animation
        activityIndicator.startAnimating()
        backgroundView.backgroundColor = UIColor.white
        backgroundView.isHidden = false
    }
    
    final func stopLoading() {
        // Stop the animation
        activityIndicator.stopAnimating()
        backgroundView.isHidden = true
    }
        
}
