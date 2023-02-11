//
//  SideMenuNavigation.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/22.
//

import UIKit
import SideMenu

final class SideMenuNavigation: SideMenuNavigationController {
//MARK: - Properties
    
    
//MARK: - LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.presentationStyle = .viewSlideOutMenuPartialIn
        self.leftSide = true
        self.menuWidth = self.view.frame.width * 0.8
        self.statusBarEndAlpha = 0
        self.presentDuration = 0.8
        self.dismissDuration = 1
    
    }
    
//MARK: - ViewMethod
    
   
    
   
//MARK: - CellMethod
    
    
  
//MARK: - DataMethod
    
   
}

