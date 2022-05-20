//
//  Extensions.swift
//  MovieList
//
//  Created by Misha Dovhiy on 21.05.2022.
//

import UIKit


extension SideBarVC {
    func toListVC(type:MovieListVC.ScreenType) {
        AppModel.Present.movieList(self, type: type)
        DispatchQueue.main.async {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            if MovieListVC.shared?.sideBarShowing ?? true {
                MovieListVC.shared?.toggleSideBar(false, animated: true)
            }
        }
    }
}
