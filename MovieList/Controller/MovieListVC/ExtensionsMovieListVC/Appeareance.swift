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
    }
    func updateUI(for type: ScreenType) {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.doubleView()
        
        switch type {
        case .all:
            sectionTitle = "Movie List"
            MovieListVC.shared = self
            sideBarPinchView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sideBarPinched(_:))))
            
        case .favorite, .search:
            self.sideBarButton.isHidden = true
            if type == .favorite {
                loadFavorites()
                sectionTitle = "Favorites"
            } else if type == .search {
                self.searchBar.isHidden = false
                self.searchBar.delegate = self
                self.collectionView.contentInset.top = 60
                NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            }
            UIView.animate(withDuration: 0.2) {
                self.collectionView.superview?.backgroundColor = Text.Colors.secondaryBacground
            }
        }
    }
    
    
    func toggleShakeButton(hide:Bool) {
        if shakeHidden != hide {
            shakeHidden = hide
            DispatchQueue.main.async {
                let space = self.view.safeAreaInsets.top + self.shakeButton.frame.maxY + 50
                let position = hide ? (space * (-1)) : 0
                
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .allowAnimatedContent) {
                    self.shakeButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, position, 0)
                    self.sideBarButton.alpha = hide ? 0 : 1
                    
                } completion: { _ in
                }

            }
        }
    }
    
    
    func viewAppeare() {
        switch screenType {
        case .all:
            SideBarVC.shared?.getData()
            addRefreshControll()
        case .favorite:
            break
        case .search:
            if !viewAppeareCalled {
                viewAppeareCalled = true
                self.searchBar.becomeFirstResponder()
            }
            
        }
    }
    
    
    
    
    
    func addRefreshControll() {
        refresh = UIRefreshControl.init(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 30))
        refresh?.tintColor = Text.Colors.white
        collectionView.addSubview(refresh ?? UIRefreshControl.init(frame: .zero))
        refresh?.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
    }
    
    @objc func refresh(sender:UIRefreshControl) {
        let new = (self.firstDispleyingPage ?? 0) - 20
        firstDispleyingPage = nil
        download(new)
    }
    

  
    
}


//scroll view
extension MovieListVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newPosition = scrollView.contentOffset.y
        if newPosition <= 5 {
            toggleShakeButton(hide: false)
        } else {
            let scrollTop = newPosition > previousScrollPosition
            if scrollTop {
                toggleShakeButton(hide: scrollTop)
                
            } else {
                if newPosition < (previousScrollPosition + 100) {
                    toggleShakeButton(hide: scrollTop)
                }
            }
        }
        
    }
    

    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let newPosition = scrollView.contentOffset.y
        previousScrollPosition = newPosition
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newPosition = scrollView.contentOffset.y
        previousScrollPosition = newPosition
    }
}
