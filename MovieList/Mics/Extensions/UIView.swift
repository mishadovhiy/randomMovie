//
//  UIView.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

extension UIView {
    func rotate(value:CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: value)
    }
    func shadow(opasity:Float = 0.6) {
        DispatchQueue.main.async {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = 10
            self.layer.shadowOpacity = opasity
        }
    }
    
    func addConstaits(_ constants:[NSLayoutConstraint.Attribute:CGFloat], superV:UIView, toSafe:Bool = false) {
        let layout = superV
        constants.forEach { (key, value) in
            let keyNil = key == .height || key == .width
            let item:Any? = keyNil ? nil : (toSafe ? layout.safeAreaLayoutGuide : layout)
            superV.addConstraint(.init(item: self, attribute: key, relatedBy: .equal, toItem: item, attribute: key, multiplier: 1, constant: value))
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addBluer(frame:CGRect? = nil, style:UIBlurEffect.Style = (.init(rawValue: -10) ?? .regular), insertAt:Int? = nil, isSecond:Bool = false) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        //prominent//dark//regular
        let bluer = UIVisualEffectView(effect: blurEffect)
        //bluer.frame = frame ?? .init(x: 0, y: 0, width: frame?.width ?? self.frame.width, height: frame?.height ?? self.frame.height)
        // view.insertSubview(blurEffectView, at: 0)

        let constaints:[NSLayoutConstraint.Attribute : CGFloat] = [.leading:0, .top:0, .trailing:0, .bottom:0]

        for _ in 0..<5 {
            let vibracity = UIVisualEffectView(effect: UIBlurEffect(style: style))
            // vibracity.contentView.addSubview()
            bluer.contentView.addSubview(vibracity)
            vibracity.addConstaits(constaints, superV: bluer)
        }
        
        bluer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let at = insertAt {
            self.insertSubview(bluer, at: at)
        } else {
            self.addSubview(bluer)
        }
        
        bluer.addConstaits(constaints, superV: self)

        return bluer
    }
    
    func addPopupBackgroundView(id:String, needBluer:Bool = false) {
        let sup = self
        let frame:CGRect = .init(x: 0, y: 0, width: sup.frame.width, height: sup.frame.height)
        let back = UIView(frame: frame)
        back.backgroundColor = .black
        back.layer.name = id
        back.alpha = 0
        sup.addSubview(back)
        if needBluer {
            let _ = back.addBluer(frame: frame)
        }
        UIView.animate(withDuration: Styles.pressedAnimation) {
            back.alpha = 1
        }
    }
    
    func contains(_ touches: Set<UITouch>) -> Bool {
        if let loc = touches.first?.location(in: self),
           frame.contains(loc) {
            return true
        } else {
            return false
        }
    }
}


extension UIActivityIndicatorView {
    var setAnimating:Bool {
        get {
            return self.isAnimating
        }
        set {
            self.isHidden = !newValue
            if newValue {
                self.startAnimating()
            } else {
                self.stopAnimating()
            }
        }
    }
}

