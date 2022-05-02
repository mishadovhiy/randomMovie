//
//  ViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let load = NetworkModel()
        load.loadMovies(page: 0) { movies, error in
            for movie in movies {
                print(movie.description)
            }
        }
    }


}

