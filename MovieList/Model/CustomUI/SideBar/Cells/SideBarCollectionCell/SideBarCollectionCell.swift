//
//  SideBarCollectionCell.swift
//  MovieList
//
//  Created by Misha Dovhiy on 05.05.2022.
//

import UIKit

class SideBarCollectionCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var _data:[SideBar.CollectionCellData.ColldetionData]?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    var data:[SideBar.CollectionCellData.ColldetionData] {
        get { return _data ?? [] }
        set {
            _data = newValue
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}




