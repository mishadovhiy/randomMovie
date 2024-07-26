//
//  Appeareance.swift
//  MovieList
//
//  Created by Misha Dovhiy on 09.05.2022.
//

import UIKit

extension MovieListVC {
    enum ScreenType {
        case all
        case favorite
        case search
        case folder
    }
    func updateUI(for type: ScreenType) {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.doubleView()
        switch type {
        case .all:
            sectionTitle = "Movie List"
        case .favorite, .search, .folder:
            if type == .favorite || type == .folder {
                DispatchQueue(label: "db", qos: .userInitiated).async {
                    self.loadFavorites()
                }
                sectionTitle = type == .favorite ? "Favorites" : selectedFolder?.name
                shakeButton.isHidden = false
                if type == .favorite || type == .folder {
                    collectionView.dragDelegate = self
                    collectionView.dropDelegate = self
                    collectionView.dragInteractionEnabled = true
                }
                if type == .folder {
                    deleteFolderButton.isHidden = false
                }
            } else if type == .search {
                self.searchBar.isHidden = false
                self.searchBar.delegate = self
                self.collectionView.contentInset.top = 60
                NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            }
            UIView.animate(withDuration: Styles.pressedAnimation) {
                self.collectionView.superview?.backgroundColor = Text.Colors.secondaryBacground
            }
            if type == .search {
                searchBar.delegate = self
            }
        }
    }
    
    
    func toggleShakeButton(hide:Bool) {
        if shakeHidden != hide {
            shakeHidden = hide
            let segment = TabBarVC.shared?.segmented
            let button = TabBarVC.shared?.sideBar?.button
            let toHide = ((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 60) * -1
            UIView.animate(withDuration: Styles.pressedAnimation, delay: 0, animations: {
                segment?.layer.move(.top, value: hide ? toHide : 0)
                button?.layer.move(.top, value: hide ? toHide : 0)

            })
        }
        if screenType == .favorite {
            self.navigationController?.setNavigationBarHidden(hide, animated: true)
        }
    }
    
    
    func viewAppeare() {
        switch screenType {
        case .all:
            let sideBar = SideBarVC.shared
            DispatchQueue(label: "db", qos: .userInitiated).async {
                sideBar?.getData()
            }
            addRefreshControll()
        case .favorite:
            if updateData {
                updateData = false
                DispatchQueue(label: "db", qos: .userInitiated).async {
                    self.loadFavorites()
                }
            }
        default:
            break
        }
    }
    
    
    
    
    
    func addRefreshControll() {
        if refresh == nil {
            refresh = UIRefreshControl.init(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 30))
            refresh?.tintColor = Text.Colors.white
            collectionView.addSubview(refresh ?? UIRefreshControl.init(frame: .zero))
            refresh?.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        }
        
    }
    
    @objc func refresh(sender:UIRefreshControl) {
        let new = (self.firstDispleyingPage ?? 0) - 20
        firstDispleyingPage = nil
        download(new)
    }
}

