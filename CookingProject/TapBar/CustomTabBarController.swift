//
//  CustomTabBarController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/16.
//

import UIKit

final class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
        let tabBarFirstItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        homeNavigationController.tabBarItem = tabBarFirstItem
        
        let notiNavigationController = UINavigationController(rootViewController: ManageNotificationViewController())
        let tabBarSecondItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 1)
        notiNavigationController.tabBarItem = tabBarSecondItem
        
        self.viewControllers = [homeNavigationController, notiNavigationController]
        
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //
    //        var tabFrame = self.tabBar.frame
    //        tabFrame.size.height = 60
    //        tabFrame.origin.y = self.view.frame.size.height - 80
    //
    //        self.tabBar.frame = tabFrame
    //
    //    }
    
//    private func customTabBar() {
//        self.tabBar.tintColor = .white
//        self.tabBar.clipsToBounds = true
//        self.tabBar.layer.masksToBounds = true
//        self.tabBar.layer.cornerRadius = tabBar.frame.height * 0.41
//        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        self.tabBar.isTranslucent = true
//    }
    
}
