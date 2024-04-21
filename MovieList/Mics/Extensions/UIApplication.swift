//
//  UIApplication.swift
//  MovieList
//
//  Created by Misha Dovhiy on 21.04.2024.
//

import UIKit

extension UIApplication {
    var keyWindow:UIWindow? {
        if #available(iOS 13.0, *) {
            let scene = self.connectedScenes.first(where: {
                let window = $0 as? UIWindowScene
                return window?.activationState == .foregroundActive && (window?.windows.contains(where: { $0.isKeyWindow && $0.layer.name == AppDelegate.shared?.selectedWindowID}) ?? false)
            }) as? UIWindowScene
            return scene?.windows.last(where: {$0.isKeyWindow }) ?? UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        } else {
            return UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        }
    }
}
