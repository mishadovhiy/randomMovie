//
//  ViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pageLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let load = NetworkModel()
    var _tableData:[Movie] = []
    
    var page:Int = 0
    var downloading = false
    var refresh:UIRefreshControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.doubleView()
        download()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh = UIRefreshControl.init(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 30))
        collectionView.addSubview(refresh ?? UIRefreshControl.init(frame: .zero))
        refresh?.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
    }
    
    var tableData:[Movie] {
        get {
            return _tableData
        }
        set {
            _tableData = newValue
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var firstDispleyingPage:Int?
    
    var loading = false
    //send bigger
    func download(_ page:Int? = nil) {
        if loading {
            return
        }
        loading = true
        let bigger = ((self.page > (page ?? 0)) && (page != nil)) ? false : true
        if !bigger {
            self.tableData = []
            
        }
        self.page = page ?? (UserDefaults.standard.value(forKey: "page") as? Int ?? 1)

        print(self.page, "pagepagepagepagepage")
        if firstDispleyingPage == nil {
            firstDispleyingPage = self.page
        }
        load.getMovies(page: self.page) { movies, error in
            UserDefaults.standard.setValue(page, forKey: "page")
            DispatchQueue.main.async {
                self.pageLabel.text = "\(self.page)"
            }
            var i = 0
            self.loading = false
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
                if self.refresh?.isRefreshing ?? true {
                    self.refresh?.endRefreshing()
                }
            }
        }
        
    }
    

    
    @objc func refresh(sender:UIRefreshControl) {
        let new = (self.firstDispleyingPage ?? 0) - 100
        firstDispleyingPage = nil
        download(new)
    }
    

}
