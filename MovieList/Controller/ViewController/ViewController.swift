//
//  ViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var screenAI: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let load = NetworkModel()
    var tableData:[Movie] = []
    var page:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        download()
        
    }

    func download(_ page:Int? = nil) {
        self.page = page ?? Int.random(in: 1..<2000)
        DispatchQueue.main.async {
            self.screenAI.startAnimating()
            self.screenAI.isHidden = false
        }
        load.randomMovies(page: self.page) { movies, error in
            self.tableData = movies
            DispatchQueue.main.async {
                if self.tableView.delegate == nil {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                }
                self.screenAI.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    func pageChanged(_ newValue:Double) {
        download()
    }

}
