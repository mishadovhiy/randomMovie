//
//  TabBarVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit

class TabBarVC: UITabBarController {

    static var shared:TabBarVC?
    override func viewDidLoad() {
        super.viewDidLoad()
        TabBarVC.shared = self
    }

    //add sidebar
    //movies requests

}
