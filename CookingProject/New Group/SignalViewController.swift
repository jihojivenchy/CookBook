//
//  SignalViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/10.
//

import UIKit


class SignalViewController : UIViewController {
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
}

