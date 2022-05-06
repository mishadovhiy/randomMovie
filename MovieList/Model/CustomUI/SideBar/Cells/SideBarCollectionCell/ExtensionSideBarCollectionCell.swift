//
//  ExtensionSideBarCollectionCell.swift
//  MovieList
//
//  Created by Misha Dovhiy on 06.05.2022.
//

import UIKit

extension SideBarCollectionCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCollectionCell", for: indexPath) as! GenresCollectionCell
        cell.nameLabel.text = data[indexPath.row].name
        return cell
    }
    
    
}

class GenresCollectionCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}
