//
//  UIActivityIndicatorView.swift
//  MovieList
//
//  Created by Misha Dovhiy on 09.05.2022.
//

import UIKit

extension UIActivityIndicatorView {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.tintColor = Text.Colors.white
    }
}
