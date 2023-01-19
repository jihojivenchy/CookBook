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
        let tabBarFirstItem = UITabBarItem(title: "Home", image: UIImage(systemName: "flame"), tag: 0)
        homeNavigationController.tabBarItem = tabBarFirstItem
        
        let setWritedNavigationController = UINavigationController(rootViewController: SaveCreatedDataViewController())
        let tabBarSecondItem = UITabBarItem(title: "Set", image: UIImage(systemName: "flame"), tag: 1)
        setWritedNavigationController.tabBarItem = tabBarSecondItem
        
        let signalNavigationController = UINavigationController(rootViewController: SignalViewController())
        let tabBarThirdItem = UITabBarItem(title: "Sign", image: UIImage(systemName: "flame"), tag: 2)
        signalNavigationController.tabBarItem = tabBarThirdItem
        
        let menuNavigationController = UINavigationController(rootViewController: MyPageViewController())
        let tabBarFourthItem = UITabBarItem(title: "My", image: UIImage(systemName: "flame"), tag: 3)
        menuNavigationController.tabBarItem = tabBarFourthItem
        
        
        self.viewControllers = [homeNavigationController, setWritedNavigationController, signalNavigationController, menuNavigationController]
        
        customTabBar()
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
    
    private func customTabBar() {
        self.tabBar.tintColor = .white
        self.tabBar.backgroundColor = .customSignature
        self.tabBar.clipsToBounds = true
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.cornerRadius = tabBar.frame.height * 0.41
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.isTranslucent = true
    }
    
}
