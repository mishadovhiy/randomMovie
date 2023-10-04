//
//  View.swift
//  Budget Tracker
//
//  Created by Mikhailo Dovhyi on 18.03.2022.
//  Copyright © 2022 Misha Dovhiy. All rights reserved.
//

import UIKit

@IBDesignable
class View: UIView {

    private var moved:Bool = false
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if !moved {
            moved = true
            firstMovedToWindow()
        }
    }
    
    func firstMovedToWindow() {
        
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            let radius = self.cornerRadius == -1 ? Styles.buttonRadius : (self.cornerRadius == -2 ? Styles.buttonRadius2 : self.cornerRadius)
            DispatchQueue.main.async {
                self.layer.cornerRadius = radius
              //  self.layer.masksToBounds = self.cornerRadius > 0
            }
        }
    }

    @IBInspectable open var shadowOpasity: Float = 0 {
        didSet {
            shadow(opasity: shadowOpasity == -1 ? Styles.buttonShadow : shadowOpasity)
        }
        
    }

}
