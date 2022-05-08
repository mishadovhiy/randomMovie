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
    
    var valueSelected:((Int) -> ())?
}




extension SideBarCollectionCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCollectionCell", for: indexPath) as! GenresCollectionCell
        cell.nameLabel.text = data[indexPath.row].name
        let ignored = data[indexPath.row].ignored
        cell.contentView.backgroundColor = ignored ? .systemGray : .white
        cell.nameLabel.textColor = ignored ? .lightGray : .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selected = valueSelected {
            selected(indexPath.row)
        }
    }
}



class GenresCollectionCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}
