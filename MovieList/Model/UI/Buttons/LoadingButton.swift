//
//  LoadingButton.swift
//  MovieList
//
//  Created by Misha Dovhiy on 09.05.2022.
//

import UIKit

class LoadingButton: Button {
    
    private var ai:UIActivityIndicatorView?
    private var touchBackground:UIView?
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.isUserInteractionEnabled = false
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if self.ai == nil {
            addAi(self.frame)
        }
        if touchBackground == nil {
            addView(self.frame)
        }
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = true
        }
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }

    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("begun", touches.first?.view?.frame)
        UIView.animate(withDuration: 0.3) {
            self.touchBackground?.alpha = 0.5
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchesInView = touchesInView(touches)
        UIView.animate(withDuration: 0.3) {
            self.touchBackground?.alpha = touchesInView ? 0.5 : 0
        }
    }
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ended dfassads \(touches.first?.location(in: self))")
        if touchesInView(touches) {
            print("!!!!")
            self.isEnabled = false
            UIView.animate(withDuration: 0.3) {
                self.touchBackground?.alpha = 0
            } completion: { _ in
                self.sendActions(for: .touchUpInside)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.touchBackground?.alpha = 0
            }
        }
        
    }
    
    
    
    override var isEnabled: Bool {
        didSet {
            setEnabled(isEnabled)
        }
    }
}


extension LoadingButton {
    func addView(_ frame:CGRect) {
        let view = UIView()
        view.backgroundColor = Text.Colors.white.withAlphaComponent(0.2)
        self.touchBackground = view
        view.alpha = 0
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(fullSize(item: view, frame: frame))
    }
    
    func addAi(_ frame:CGRect) {
        let ai = UIActivityIndicatorView()
        self.ai = ai
        self.addSubview(ai)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .black
        ai.backgroundColor = Text.Colors.white.withAlphaComponent(0.2)
        self.addConstraints(fullSize(item: ai, frame: frame))
        ai.hidesWhenStopped = true
        setEnabled(isEnabled)
    }
    
    
    private func setEnabled(_ value:Bool) {
        if let ai = ai {
            if isEnabled {
                UIView.animate(withDuration: 0.3) {
                    ai.alpha = 0
                } completion: { _ in
                    ai.stopAnimating()
                    ai.alpha = 1
                }

            } else {
                if ai.isHidden {
                    ai.isHidden = false
                }
                ai.startAnimating()
            }
        }
    }
    
    func fullSize(item:Any, frame:CGRect) -> [NSLayoutConstraint] {
        return [
            .init(item: item, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0),
            .init(item: item, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0),
            .init(item: item, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0),
            .init(item: item, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0),
            .init(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: frame.width),
            .init(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: frame.height)
        ]
    }
    
    
    func touchesInView(_ touches: Set<UITouch>) -> Bool {
        if let location = touches.first?.location(in: self) {
            let frame = self.layer.frame
            if ((location.x > 0) && (location.x < frame.width)) &&
                ((location.y > 0) && (location.y < frame.height)) {
                return true
            }
        }
        return false
    }
}
