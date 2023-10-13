//
//  UINavigationController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 13.10.2023.
//

import UIKit

extension UINavigationController {
    func setBackButton(vc:UIViewController) {
        self.navigationBar.backIndicatorImage = UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationBar.isTranslucent = true
        removeDefaultLine()
    }
    
    func removeDefaultLine() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}
