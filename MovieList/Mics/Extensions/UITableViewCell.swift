//
//  UITableViewCell.swift
//  MovieList
//
//  Created by Misha Dovhiy on 05.05.2022.
//

import UIKit

extension UITableViewCell {

    
    func setSelectionBackground(_ color:UIColor) {
        let selected = UIView(frame: .zero)
        selected.backgroundColor = color
        self.selectedBackgroundView = selected
    }
}
