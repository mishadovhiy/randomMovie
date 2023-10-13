//
//  UITableView.swift
//  MovieList
//
//  Created by Misha Dovhiy on 13.10.2023.
//

import UIKit

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
