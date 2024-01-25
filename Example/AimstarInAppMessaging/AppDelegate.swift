//
//  AppDelegate.swift
//  AimstarInAppMessaging
//
//  Created by k-kubo on 2024/01/18.
//

import UIKit
import AimstarInAppMessagingSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let API_KEY = "Your API KEY"
        let TENANT_ID = "Your TENANT ID"
        // SDKの初期化を行います
        AimstarInAppMessaging.shared.setup(apiKey: API_KEY, tenantId: TENANT_ID)
        // イベントリスナーの設定
        AimstarInAppMessaging.shared.delegate = self
        return true
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

extension AppDelegate: AimstarInAppMessagingDelegate {
    func messageDismissed(_ message: InAppMessage) {
        debugPrint("messageDismissed")
    }
    
    func messageClicked(_ message: InAppMessage) {
        debugPrint("messageClicked")
    }
    
    func messageDetectedForDisplay(_ message: InAppMessage) {
        debugPrint("messageDetectedForDisplay")
    }
    
    func messageError(_ message: InAppMessage?, error: Error) {
        debugPrint("messageError")
    }
}
