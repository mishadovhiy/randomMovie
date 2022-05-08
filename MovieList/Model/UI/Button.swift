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
            DispatchQueue.main.async {
                self.layer.cornerRadius = self.cornerRadius
                self.layer.masksToBounds = self.cornerRadius > 0
            }
        }
    }
    
    @IBInspectable open var shadowOpasity: Float = 0 {
        didSet {
            DispatchQueue.main.async {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOffset = .zero
                self.layer.shadowRadius = 10
                self.layer.shadowOpacity = self.shadowOpasity
            }
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.ai == nil {
            addAi()
        }
    }

    
    private func addAi() {
        let ai = UIActivityIndicatorView()
        self.ai = ai
        self.addSubview(ai)
        
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        ai.color = .black
        ai.backgroundColor = .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        
        self.addConstraints([
            .init(item: ai, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0),
            .init(item: ai, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0),
            .init(item: ai, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0),
            .init(item: ai, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0),
            .init(item: ai, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.frame.width),
            .init(item: ai, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: self.frame.height)
        ])
        ai.hidesWhenStopped = true
        ai.isHidden = self.isEnabled
      //  if ai.isHidden != self.isEnabled {
      //      ai.isHidden = self.isEnabled
      //  }
        

    }
    
    private var ai:UIActivityIndicatorView?
    
    override var isEnabled: Bool {
        didSet {
            print(Thread.isMainThread, " isMainThread")
            print(isEnabled)
            if let ai = ai {
                if isEnabled {
                   // DispatchQueue.main.async {
                        ai.stopAnimating()
                 //   }
                } else {
               //     DispatchQueue.main.async {
                        if ai.isHidden {
                            ai.isHidden = false
                        }
                        ai.startAnimating()
                //    }
                }
            }
        }
    }
    
    
}
