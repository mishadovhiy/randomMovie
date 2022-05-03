//
//  ViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let load = NetworkModel()
    var _tableData:[Movie] = []
    
    var page:Int = 0
    var downloading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.doubleView()
        download()
        
    }

    var tableData:[Movie] {
        get {
            return _tableData
        }
        set {
            _tableData = newValue
            print(tableData.count, " tableDatatableDatatableData NEWVALUE")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func download(_ page:Int? = nil) {
        self.page = page ?? (UserDefaults.standard.value(forKey: "page") as? Int ?? 1)
        print(self.page, "pagepagepagepagepage")
        load.getMovies(page: self.page) { movies, error in
            UserDefaults.standard.setValue(page, forKey: "page")
            var i = 0
            for movie in movies {
                if movie.image == nil && movie.imageURL != "" {
                    self.load.image(for: movie.imageURL) { data in
                        movie.image = data
                        self.tableData.append(movie)
                        
                    }
                } else {
                    self.tableData.append(movie)
                }
                i += 1
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    

    

}
