//
//  UITableViewExtension.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

extension MovieListVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch screenType {
        case .all: return 3
        case .favorite, .folder: return 3
        case .search: return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sectionTitle == nil ? 0 : 1
        case 1:
            return tableData.count
        case 2:
            switch screenType {
            case .all, .folder: return 1
            case .favorite: return folders.count + 1
            default: return 0
            }
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    enum CellType {
        case title
        case preview
        case loader
    }
    
    private func cellType(for indexPath:IndexPath) -> CellType {
        let cellType:CellType
        if indexPath.section == 1 || ((screenType == .favorite || screenType == .folder) && indexPath.section == 2) {
            cellType = .preview
        } else if indexPath.section == 0 {
            cellType = .title
        } else {
            cellType = .loader
        }
        return cellType
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isFolderCell = (screenType == .favorite || screenType == .folder) && indexPath.section == 2
        let cellType = cellType(for: indexPath)
        
        switch cellType {
        case .title:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionCell", for: indexPath) as! TitleCollectionCell
            cell.set(title: sectionTitle ?? "", titleChanged: selectedFolder != nil ? folderNameChanged(_:) : nil)
            return cell
        case .preview:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewCollectionCell", for: indexPath) as! PreviewCollectionCell
            //            if (isFolderCell ? folders.count : tableData.count) <= indexPath.row || (isFolderCell && folders.count == indexPath.row) {
            //                return cell
            //            }
            let anyData:Any = isFolderCell ? (folders.count >= (indexPath.row + 1) ? folders[indexPath.row] : .init(id: -1, name: "Create Folder")) : tableData[indexPath.row]
            let data = anyData as? Movie
            let folderData = anyData as? LocalDB.DB.Folder
            cell.touchesBegun = { begun in
                // (cell.contentView as? TouchView)?.layer.performAnimation(key: .zoom, to: begun ? CGFloat(1.02) : CGFloat(1))
                UIView.animate(withDuration: Styles.pressedAnimation, delay: 0, options: .allowUserInteraction, animations: {
                    cell.contentView.layer.zoom(value: begun ? 1.01 : 1)
                })
            }
            if let data {
                cell.imdbLabel.text = data.imdbrating > 0 ? String.init(decimalsCount: 1, from: data.imdbrating) : "0"
                if let imageData = data.image ?? load.localImage(url: data.imageURL),
                   let image = UIImage(data:imageData) {
                    cell.movieImage.image = image
                } else if data.imageURL != "" {
                    DispatchQueue(label: "api", qos: .userInitiated).async {
                        self.load.image(for: data.imageURL, completion: { res in
                            if #available(iOS 13.0, *) {
                                DispatchQueue.main.async {
                                    cell.movieImage.image = .init(data: res ?? .init()) ?? UIImage(systemName: "photo.fill")
                                }
                            }
                        })
                    }
                } else {
                    if #available(iOS 13.0, *) {
                        cell.movieImage.image = UIImage(systemName: "photo.fill")
                    }
                }
                cell.movieImage.contentMode = .scaleAspectFill
            } else {
                cell.imdbLabel.text = ""
                if #available(iOS 13.0, *) {
                    cell.movieImage.image = screenType == .folder ? UIImage(named: "trash") : UIImage(systemName: "folder.fill")
                    cell.movieImage.contentMode = .center
                }
            }
            let title = screenType == .folder ? "Drag here to remove from Folder" : data?.name ?? folderData?.name
            cell.titleLabel.text = title
            cell.dateLabel.text = title
            return cell
        case .loader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCollectionCell", for: indexPath) as! LoadingCollectionCell
            cell.setCell(animating: indexPath.section == 2 ? !stopDownloading : false, title: indexPath.section == 2 ? "" : "Create Folder")
            return cell
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
        switch cellType(for: indexPath) {
        case .preview:
            let isFolderCell = screenType == .favorite && indexPath.section == 2
            if !isFolderCell && !(screenType == .folder && indexPath.section == 2) {
                //  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewCollectionCell", for: indexPath) as! PreviewCollectionCell
                let cellRow = collectionView.cellForItem(at: indexPath) as! PreviewCollectionCell
                selectedImageView = cellRow.movieImage
                selectedImageView?.image = cellRow.movieImage.image
                selectedMovie = tableData[indexPath.row]
            } else if folders.count == indexPath.row, screenType != .folder {
                createFolderPressed()
            } else if folders.count > indexPath.row, screenType != .folder {
                let vc = MovieListVC.configure(type: .folder, folder: folders[indexPath.row]) {
                    self.updateData = true
                }
                if let nav = self.navigationController {
                    nav.pushViewController(vc, animated: true)
                } else {
                    self.present(vc, animated: true)
                }
            }
        case .loader:
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
            if selectedFolder != nil {
                let cellRow = collectionView.cellForItem(at: indexPath) as! TitleCollectionCell
                cellRow.textField.becomeFirstResponder()
            }
        }
        
    }
    
    
    var collectionCellWidth:CGFloat {
        return (collectionView.frame.width / 3) - 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellType(for: indexPath) == .preview {
            return .init(width: collectionCellWidth, height: 180)
        } else {
            return .init(width: collectionView.frame.width, height: indexPath.section == 0 ? 80 : 180)
        }
        
    }
    
}

extension MovieListVC:UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.section == 1 {
            dragIndex = indexPath
            let itemProvider = UIDragItem(itemProvider: NSItemProvider(object: "\(indexPath.row)" as NSItemProviderWriting))
            itemProvider.localObject = tableData[indexPath.row]
            return [itemProvider]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: any UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        print(session, " tgrfeds")
        let allowSections = [1, 2]
        if collectionView.hasActiveDrag && allowSections.contains(destinationIndexPath?.section ?? 0) && !(destinationIndexPath?.section == 2 && folders.count == destinationIndexPath?.row) {
            if session.localDragSession != nil {
                return UICollectionViewDropProposal(operation: .move, intent: destinationIndexPath?.section == 2 ? .insertIntoDestinationIndexPath : .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UICollectionViewDropProposal(operation: .forbidden, intent: .unspecified)
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: any UIDropSession) {
        print(session, " gtrfeds")
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: any UIDropSession) {
        print(session, " rtgerfwd")
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: any UICollectionViewDropCoordinator) {
        reloadAction?()
        guard let dragIndex else {
            return
        }
        if let destinationIndexPath = coordinator.destinationIndexPath, destinationIndexPath.section == 2 {
            print(destinationIndexPath, " rytegrfwed")
            let value = tableData[dragIndex.row]
            tableData.remove(at: dragIndex.row)
            collectionView.deleteItems(at: [dragIndex])
            DispatchQueue(label: "db", qos: .userInitiated).async {
                let new = LocalDB.db.favoriteMovies.first(where: {$0.imdbid == value.imdbid})
                let toFolder = self.folders.count >= destinationIndexPath.row + 1 ? self.folders[destinationIndexPath.row].id : nil
                print(toFolder, " tefrdwerfgtr")
                new?.folderID = self.screenType == .favorite ? toFolder : nil
                if let new {
                    LocalDB.db.favoriteMovies.removeAll(where: {$0.imdbid == value.imdbid})
                    LocalDB.db.favoriteMovies.append(new)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: any UIDropSession) {
        dragIndex = nil
    }
    
}
