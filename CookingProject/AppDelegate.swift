//
//  AppDelegate.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/08.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseFirestore
import KakaoSDKCommon
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        
        KakaoSDK.initSDK(appKey: "c992fa6c24b3d9b23179ef2b3c43d3f2")
        settingNaverSNSLogin()
        
        return true
    }
    
    //세로모드 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    private func settingNaverSNSLogin() {
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        //네이버 앱으로 인증하는 방식 활성화
        instance?.isNaverAppOauthEnable = true
        
        //SafariViewController에서 인증하는 방식 활성화
        instance?.isInAppOauthEnable = true
        
        //인증 화면을 아이폰의 세로모드에서만 적용
        instance?.isOnlyPortraitSupportedInIphone()
        
        instance?.serviceUrlScheme = "naverlogin"           //앱 등록할 때 입력한 URL Scheme
        instance?.consumerKey = "qDtDbjxCu0BxnxmTmMg4"      //앱 등록 후 발급받은 클라이언트 아이디
        instance?.consumerSecret = "hmVbS3M70q"             //앱 등록 후 발급받은 클라이언트 시크릿
        instance?.appName = "요리도감"                        //앱 이름
    }
}
