//
//  Extensions.swift
//  MovieList
//
//  Created by Misha Dovhiy on 21.05.2022.
//

import UIKit


extension SideBarVC {
    func toListVC(type:MovieListVC.ScreenType) {
        DispatchQueue.main.async {
            AppModel.Present.movieList(TabBarVC.shared!, type: type)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            if TabBarVC.shared?.sideBar?.isShowing ?? true {
                TabBarVC.shared?.sideBar?.toggleSideBar(false, animated: true)
            }
        }
    }
}
