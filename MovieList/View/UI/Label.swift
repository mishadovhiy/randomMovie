//
//  Label.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

@IBDesignable
class Label: UILabel {

    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            DispatchQueue.main.async {
                self.layer.cornerRadius = self.cornerRadius
                self.layer.masksToBounds = self.cornerRadius > 0
            }
        }
    }


}
