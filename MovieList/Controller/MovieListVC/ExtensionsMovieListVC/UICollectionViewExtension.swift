//
//  UITableViewExtension.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

extension MovieListVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return screenType == .all ? 3 : (screenType == .all ? 3 : 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sectionTitle == nil ? 0 : 1
        case 1:
            return tableData.count
        case 2:
            return screenType == .all ? 1 : 0
        case 3:
            return 1
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
            if tableData.count <= indexPath.row {
                return cell
            }
            let data = tableData[indexPath.row]
            cell.touchesBegun = { begun in
               // (cell.contentView as? TouchView)?.layer.performAnimation(key: .zoom, to: begun ? CGFloat(1.02) : CGFloat(1))
                UIView.animate(withDuration: Styles.pressedAnimation, delay: 0, options: .allowUserInteraction, animations: {
                    cell.contentView.layer.zoom(value: begun ? 1.01 : 1)
                })
            }
            cell.dateLabel.text = data.released
            cell.imdbLabel.text = data.imdbrating > 0 ? String.init(decimalsCount: 1, from: data.imdbrating) : "0"
            cell.titleLabel.text = data.name
            if let imageData = data.image ?? load.localImage(url: data.imageURL),
               let image = UIImage(data:imageData) {
                cell.movieImage.image = image
            } /*else if data.imageURL != "" {
                DispatchQueue(label: "api", qos: .userInitiated).async {
                    self.load.image(for: data.imageURL, completion: { res in
                        DispatchQueue.main.async {
                            cell.movieImage.image = .init(data: res ?? .init()) ?? UIImage(systemName: "photo.fill")
                        }
                    })
                }
            }*/ else {
                if #available(iOS 13.0, *) {
                    cell.movieImage.image = UIImage(systemName: "photo.fill")
                } 
            }
            

            
            return cell
        case 2, 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCollectionCell", for: indexPath) as! LoadingCollectionCell
            cell.setCell(animating: indexPath.section == 2 ? !stopDownloading : false, title: indexPath.section == 2 ? "" : "Create Folder")
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 2 && !stopDownloading {
            DispatchQueue(label: "db", qos: .userInitiated).async {
                let page = LocalDB.db.page + 1
                DispatchQueue.main.async {
                    self.download()

                }
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewCollectionCell", for: indexPath) as! PreviewCollectionCell
            let cellRow = collectionView.cellForItem(at: indexPath) as! PreviewCollectionCell
            selectedImageView = cellRow.movieImage
            selectedImageView?.image = cellRow.movieImage.image
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
        case 3:
            self.createFolderPressed()
        default:
            break
        }
        
    }
    

    var collectionCellWidth:CGFloat {
        return (collectionView.frame.width / 3) - 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return .init(width: collectionCellWidth, height: 180)
        } else {
            return .init(width: collectionView.frame.width, height: indexPath.section == 0 ? 80 : 180)
        }
        
    }

}
