//
//  SceneDelegate.swift
//  MovieList
//
//  Created by Misha Dovhiy on 21.04.2024.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = BaseWindow.init(windowScene: windowScene)
        window?.layer.name = UUID().uuidString
        window?.rootViewController = TabBarVC.configure()
        window?.makeKeyAndVisible()
        AppDelegate.shared?.selectedWindowID = window?.layer.name ?? ""
    }
}

class BaseWindow:UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        AppDelegate.shared?.selectedWindowID = layer.name ?? ""
        return super.hitTest(point, with: event)
    }
}
