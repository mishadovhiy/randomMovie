//
//  UIViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 08.05.2022.
//

import UIKit

extension UIViewController {
    func vibrate(style: UIImpactFeedbackGenerator.FeedbackStyle?) {
        let styleResult = style ?? .soft
        UIImpactFeedbackGenerator(style: styleResult).impactOccurred()
    }
}

