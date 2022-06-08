//
//  AppDelegate.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var shared:AppDelegate?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppDelegate.shared = self
        return true
    }

    
    private let analyticsName = "AppDelegate"
    // MARK: UISceneSession Lifecycle

    func applicationDidBecomeActive(_ application: UIApplication) {
        AnalyticModel.shared.analiticStorage.append(.init(key: #function.description, action: analyticsName))
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        AnalyticModel.shared.analiticStorage.append(.init(key: #function.description, action: analyticsName))
        AnalyticModel.shared.checkData()
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        AnalyticModel.shared.analiticStorage.append(.init(key: #function.description, action: analyticsName))
    }

}

