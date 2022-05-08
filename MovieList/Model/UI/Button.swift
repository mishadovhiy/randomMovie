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
    
}
