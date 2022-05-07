//
//  LoadingCollectionCell.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

class LoadingCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var ai: UIActivityIndicatorView!

    func setCell(animating:Bool) {
        let hideLabel = animating
        if mainLabel.isHidden != hideLabel {
            mainLabel.isHidden = hideLabel
        }
        if animating {
            if ai.isAnimating != true {
                ai.startAnimating()
            }
        } else {
            if ai.isAnimating != false {
                ai.stopAnimating()
            }
        }
    }
}
