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


extension CALayer {
    func shadow(opasity:Float = 0.6, offset:CGSize = .init(width: 0, height: 0), color:UIColor? = nil, radius:CGFloat = 10) {
        self.shadowColor = (color ?? .black).cgColor
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.shadowOpacity = opasity
    }
    func radius(_ value:CGFloat? = nil, at:RadiusAt) {
        self.cornerRadius = value ?? (self.frame.height / 2)
        self.maskedCorners = at.masks
    }

    enum RadiusAt {
        case top
        case btn
        case left
        case right
        
        var masks: CACornerMask {
            switch self {
            case .top:
                return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .btn:
                return [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            case .left:
                return [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            case .right:
                return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            }
        }
    }
    enum MoveDirection {
        case top
        case left
    }
    
    func move(_ direction:MoveDirection, value:CGFloat) {
        switch direction {
        case .top:
            self.transform = CATransform3DTranslate(CATransform3DIdentity, 0, value, 0)
        case .left:
            self.transform = CATransform3DTranslate(CATransform3DIdentity, value, 0, 0)
        }
    }
    func zoom(value:CGFloat) {
        self.transform = CATransform3DMakeScale(value, value, 1)
    }
    
    func drawSeparetor(space:CGPoint = .init(x: 0, y: 0), opasity:Float = 1) -> CAShapeLayer? {
        return self.drawLine([
            .init(x: space.x, y: self.frame.height),
            .init(x: self.frame.width - space.y, y: self.frame.height)
        ], color: .init(named: "DarkGreyColor"), opacity: opasity)
    }
    func drawLine(_ lines:[CGPoint], color:UIColor? = nil, width:CGFloat = 0.5, opacity:Float = 0.1, background:UIColor? = nil, insertAt:UInt32? = nil, name:String? = nil) -> CAShapeLayer? {
        
        let col = color ?? UIColor.init(named: "DarkGreyColor")
        let line = CAShapeLayer()
        let contains = self.sublayers?.contains(where: { $0.name == (name ?? "")} )
        let canAdd = name == nil ? true : !(contains ?? false)
        if canAdd {
            line.path = createPath(lines).cgPath
            line.opacity = opacity
            line.lineWidth = width
            line.strokeColor = (col ?? .red).cgColor
            line.name = name
            if let background = background {
                line.backgroundColor = background.cgColor
                line.fillColor = background.cgColor
            }
            if let at = insertAt {
                self.insertSublayer(line, at: at)
            } else {
                self.addSublayer(line)
            }
            
            return line
        } else {
            return nil
        }
        
    }
    func createPath(_ lines:[CGPoint]) -> UIBezierPath {
        let linePath = UIBezierPath()
        var liness = lines
        guard let lineFirst = liness.first else { return .init() }
        linePath.move(to: lineFirst)
        liness.removeFirst()
        liness.forEach { line in
            linePath.addLine(to: line)
        }
        return linePath
    }
    
    enum KeyPath:String {
        case height = "bounds.size.height"
        case background = "backgroundColor"
        case zoom = "transform.scale"
        
        func from(_ view:CALayer) -> Any {
            switch self {
            case .height:
                return view.bounds.size.height
            case .background:
                return view.backgroundColor ?? UIColor.black.cgColor
            case .zoom: return CGFloat(1)
            }
        }
        
        func to(_ view:CALayer) -> Any? {
            switch self {
            case .height:
                return 0
            case .background:
                return nil
            case .zoom: return nil
            }
        }
        
        func set(to:Any?, view:CALayer) {
            switch self {
            case .height:
                view.bounds.size.height = ((to ?? self.to(view)) as? CGFloat ?? 0)
            case .background:
                view.backgroundColor = ((to ?? self.to(view)) as! CGColor)
            case .zoom:
                let to = (to ?? self.to(view)) as! CGFloat
                view.transform = CATransform3DMakeScale(to, to, 1)
            }
        }
    }

    enum AnimationKey:String {
        case general = "backgroundpress"
        case general1 = "backgroundpress1"
        
    }
    
    func performAnimation(key:KeyPath,
                          to:Any? = nil,
                          code:AnimationKey = .general,
                          duration:CGFloat = 0.3,
                          completion:(()->())? = nil
    ) {
     //   self.removeAnimation(forKey: key.rawValue)
        let animation = CABasicAnimation(keyPath: key.rawValue)
        animation.fromValue = key.from(self)
        animation.toValue = to ?? key.to(self)
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime()
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            key.set(to: to, view: self)
            completion?()
        }
        self.add(animation, forKey: code.rawValue)
        CATransaction.commit()
    }
}


extension UIColor {
    private func makeColor(componentDelta: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0

        
        getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )
        
        return UIColor(
            red: add(componentDelta, toComponent: red),
            green: add(componentDelta, toComponent: green),
            blue: add(componentDelta, toComponent: blue),
            alpha: alpha
        )
    }
    
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
    
    func lighter(_ componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: componentDelta)
    }
    
    func darker(_ componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: -1*componentDelta)
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

extension UINavigationController {
    func setBackButton(vc:UIViewController) {
        self.navigationBar.backIndicatorImage = UIImage(systemName: "xmark")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "xmark")
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
