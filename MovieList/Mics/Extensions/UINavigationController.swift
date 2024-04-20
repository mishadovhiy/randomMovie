//
//  UINavigationController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 13.10.2023.
//

import UIKit

extension UINavigationController {
    func setBackButton(vc:UIViewController) {
        let color = #colorLiteral(red: 0.9100000262, green: 0.9100000262, blue: 0.9100000262, alpha: 1).withAlphaComponent(0.3)
        if #available(iOS 13.0, *) {
            self.navigationBar.backIndicatorImage = UIImage(systemName: "xmark")?.withTintColor(color, renderingMode: .alwaysOriginal)
            self.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "xmark")?.withTintColor(color, renderingMode: .alwaysOriginal)
        }
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationBar.isTranslucent = true
        removeDefaultLine()
    }
    
    func removeDefaultLine() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}
