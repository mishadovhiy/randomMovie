//
//  UIViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 08.05.2022.
//

import UIKit

extension UIViewController {
    func vibrate() {
        if #available(iOS 13.0, *) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
