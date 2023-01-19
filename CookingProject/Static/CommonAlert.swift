//
//  CommonAlert.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/17.
//

import UIKit

struct CommonAlert {
    
    static func alert(title : String, subMessage : String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: subMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        
        return alert
    }
}
