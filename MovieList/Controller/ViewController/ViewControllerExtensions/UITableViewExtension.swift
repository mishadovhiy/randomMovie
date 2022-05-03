//
//  UITableViewExtension.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tableData.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewCollectionCell", for: indexPath) as! PreviewCollectionCell
            let data = tableData[indexPath.row]
            
            cell.dateLabel.text = data.released
            cell.imdbLabel.text = "\(data.imdbrating)"//String.init(format: "%.2f", data.imdbrating)
            cell.titleLabel.text = data.name
            print("data.imageURLdata.imageURL", data.imageURL)
            if let imageData = data.image ?? load.localImage(url: data.imageURL),
               let image = UIImage(data:imageData) {
                cell.movieImage.image = image
            } else {
                cell.movieImage.image = UIImage(systemName: "photo.fill")
            }
            

            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCollectionCell", for: indexPath) as! LoadingCollectionCell
            cell.ai.startAnimating()
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            download(page + 1)
        }
    }
    

    
}
