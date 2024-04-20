//
//  UIViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 08.05.2022.
//

import UIKit

extension UIViewController {
    func vibrate(style: UIImpactFeedbackGenerator.FeedbackStyle?) {
        if #available(iOS 13.0, *) {
            let styleResult = style ?? .soft
            UIImpactFeedbackGenerator(style: styleResult).impactOccurred()
        } else {
            let styleResult = style ?? .light
            UIImpactFeedbackGenerator(style: styleResult).impactOccurred()
        }
    }
    
    
    static var panIndicatorLayerName:String = "PanIndicatorViewPrimary"
    
    func createPanIndicator() {
        if !self.view.subviews.contains(where: {$0.layer.name == UIViewController.panIndicatorLayerName}) {
            let view = UIView()
            view.isUserInteractionEnabled = false
            view.backgroundColor = #colorLiteral(red: 0.9100000262, green: 0.9100000262, blue: 0.9100000262, alpha: 1).withAlphaComponent(0.5)
            view.layer.cornerRadius = 2
            view.layer.name = UIViewController.panIndicatorLayerName
            view.alpha = 0.1
            self.view.addSubview(view)
            let topMinus = self.navigationController?.navigationBar.frame.height ?? 0
            view.addConstaits([.top: 1 - topMinus, .centerX:0, .width:45, .height:4], superV: self.view, toSafe: true)
        }
        
    }
    
}

