//
//  UITableViewCell.swift
//  MovieList
//
//  Created by Misha Dovhiy on 05.05.2022.
//

import UIKit

extension UITableViewCell {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        setSelectionBackground(.clear)
    }
    func setSelectionBackground(_ color:UIColor = .clear) {
        let selected = UIView(frame: .zero)
        selected.backgroundColor = color
        self.selectedBackgroundView = selected
    }
}

extension UICollectionViewCell {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        setSelectionBackground(.clear)
    }
    func setSelectionBackground(_ color:UIColor = .clear) {
        let selected = UIView(frame: .zero)
        selected.backgroundColor = color
        self.selectedBackgroundView = selected
    }
}
