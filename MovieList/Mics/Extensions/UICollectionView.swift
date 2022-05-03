//
//  UICollectionView.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

extension UICollectionView {
    func doubleView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .vertical
        let width = (self.frame.width - 5)/3
        layout.itemSize = CGSize(width: width, height: width + 20)
        self.collectionViewLayout = layout
    }
}
