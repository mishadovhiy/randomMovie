//
//  TouchView.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit

class TouchView: View {

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
    
    var animationCompleted:Bool = true
    private var animationCompletionAction:(()->())?
    
    private func touch(_ begun:Bool) {
        if let customAnimation = customTouchAnimation {
            customAnimation(begun)
            return
        } else {
            animationCompleted = false
            self.defaultAnimation(begun: begun)
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touch(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchesEnded()
        if self.contains(touches) {
            pressed?()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touch(self.contains(touches))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touch(false)
    }
    
    
    func touchesEnded() {
        touch(false)
    }
    
    private func defaultAnimation(begun:Bool) {
        let defaultColor = self.backHolder ?? .white
        UIView.animate(withDuration: Styles.pressedAnimation, delay: 0, options: .allowUserInteraction) {
            self.backgroundColor = begun ? defaultColor.lighter(Styles.viewPressedComponentDelta) : defaultColor
        }
    }

}
