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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        download()
        
    }

    func download(_ page:Int? = nil) {
        let pageResult = page ??  UserDefaults.standard.value(forKey: "PageNumber") as? Int ?? 0
        DispatchQueue.main.async {
            self.screenAI.startAnimating()
            self.screenAI.isHidden = false
        }
        load.loadMovies(page: pageResult) { movies, error in
            self.tableData = movies
            for i in 0..<movies.count {
                print(movies[i].description)
            }
            DispatchQueue.main.async {
                self.screenAI.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    func pageChanged(_ newValue:Double) {
        
        let n = Int(newValue)
        UserDefaults.standard.setValue(n, forKey: "PageNumber")
        download(n)
    }

}
