//
//  Button.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

@IBDesignable
class Button: UIButton {
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            let radius = self.cornerRadius == -1 ? Styles.buttonRadius : (self.cornerRadius == -2 ? Styles.buttonRadius2 : self.cornerRadius)
            DispatchQueue.main.async {
                self.layer.cornerRadius = radius
                self.layer.masksToBounds = radius > 0
            }
        }
    }
    
    @IBInspectable open var shadowOpasity: Float = 0 {
        didSet {
            DispatchQueue.main.async {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOffset = .zero
                self.layer.shadowRadius = 10
                self.layer.shadowOpacity = self.shadowOpasity == -1 ? Styles.buttonShadow : self.shadowOpasity
            }
        }
    }
    
    
    @IBInspectable open var tintBackground: Bool = false {
        didSet {
            DispatchQueue.main.async {
                let color = self.tintColor.withAlphaComponent(Styles.opacityBackground)
                self.backgroundColor = color
                self.backHolder = color
            }
        }
    }
    

    var pressed:(()->())?
    var customTouchAnimation:((_ touched:Bool) ->())?
    
    private var backHolder:UIColor?
    override var backgroundColor: UIColor? {
        get { return super.backgroundColor }
        set {
            if backHolder == nil {
                backHolder = newValue
            }
            super.backgroundColor = newValue
        }
    }
    
    private var animationCompleted:Bool = true
    private var animationCompletionAction:(()->())?
    
    func touch(_ begun:Bool) {
        if let customAnimation = customTouchAnimation {
            customAnimation(begun)
        } else {
            self.defaultAnimation(begun: begun)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touch(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touch(false)
        if self.contains(touches) {
            pressed?()
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touch(false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touch(false)
    }
    
    
    private func defaultAnimation(begun:Bool) {
        let defaultColor = self.backHolder ?? (begun ? (self.tintColor ?? .red) : .clear)

        UIView.animate(withDuration: Styles.pressedAnimation, delay: 0, options: .allowUserInteraction) {
            self.backgroundColor = begun ? defaultColor.lighter(Styles.buttonPressedComponentDelta) : defaultColor
        }
    }

}
