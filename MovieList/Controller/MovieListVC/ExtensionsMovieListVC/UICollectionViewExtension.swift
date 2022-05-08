//
//  UITableViewExtension.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

extension MovieListVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return screenType == .all ? 3 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sectionTitle == nil ? 0 : 1
        case 1:
            return tableData.count
        case 2:
            return screenType == .all ? 1 : 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionCell", for: indexPath) as! TitleCollectionCell
            cell.mainLabel.text = sectionTitle
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewCollectionCell", for: indexPath) as! PreviewCollectionCell
            let data = tableData[indexPath.row]
            
            cell.dateLabel.text = data.released
            cell.imdbLabel.text = data.imdbrating > 0 ? String.init(decimalsCount: 1, from: data.imdbrating) : "0"
            cell.titleLabel.text = data.name
            if let imageData = data.image ?? load.localImage(url: data.imageURL),
               let image = UIImage(data:imageData) {
                cell.movieImage.image = image
            } else {
                cell.movieImage.image = UIImage(systemName: "photo.fill")
            }
            

            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCollectionCell", for: indexPath) as! LoadingCollectionCell
            cell.setCell(animating: !stopDownloading)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 2 && !stopDownloading {
            download(page + 1)
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            selectedMovie = tableData[indexPath.row]
        case 2:
            if stopDownloading {
                stopDownloading = false
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
                if tableData.count > 50 {
                    tableData = []
                }
            }
        default:
            break
        }
        
    }
    


}
