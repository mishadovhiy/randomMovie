//
//  SideBarExtension.swift
//  MovieList
//
//  Created by Misha Dovhiy on 06.05.2022.
//

import UIKit

extension MovieListVC {
    
    @objc func sideBarPinched(_ sender: UIPanGestureRecognizer) {
        let finger = sender.location(in: self.view)
        if sender.state == .began {
            sidescrolling = finger.x < 80
            wasShowingSideBar = sideBarShowing
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            } else {
                // Fallback on earlier versions
            }
        }
        if sidescrolling || sideBarShowing {
            if sender.state == .began || sender.state == .changed {
                let newPosition = finger.x
                UIView.animate(withDuration: 0.1) {
                    self.mainContentView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, newPosition, 0, 0)
                }

            } else {
                if sender.state == .ended {
                    let toHide:CGFloat = wasShowingSideBar ? 200 : 80
                    toggleSideBar(finger.x > toHide ? true : false, animated: true)
                }
            }
        }
        
    }
    func toggleSideBar(_ show: Bool, animated:Bool) {
        sideBarShowing = show
        DispatchQueue.main.async {
            let frame = self.sideBar.layer.frame
            UIView.animate(withDuration: animated ? 0.25 : 0) {
                self.mainContentView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, show ? frame.width : 0, 0, 0)
            } completion: { _ in
                if show {
                    self.sideBar.getData()
                }
                self.sideBar.isUserInteractionEnabled = show
                self.collectionView.reloadData()
            }

        }
    }

    
    
}
