//
//  UIViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 08.05.2022.
//

import UIKit

extension UIViewController {
    func vibrate() {
        if #available(iOS 13.0, *) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}

extension UITableView {
    func registerCell(_ types:[XibCell]) {
        types.forEach({
            self.register(UINib(nibName: $0.rawValue, bundle: nil), forCellReuseIdentifier: $0.rawValue)
        })
    }
    enum XibCell:String {
        case noData = "NoDataCell"
    }
}
