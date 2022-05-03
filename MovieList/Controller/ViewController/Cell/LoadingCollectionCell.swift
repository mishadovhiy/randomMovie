//
//  LoadingCollectionCell.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

class LoadingCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var ai: UIActivityIndicatorView!
    override func didMoveToWindow() {
        super.didMoveToWindow()
        ai.startAnimating()
        
    }
}
