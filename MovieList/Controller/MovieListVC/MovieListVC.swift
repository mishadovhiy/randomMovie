//
//  ViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class MovieListVC: BaseVC {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var shakeButton: Button!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    static var shared:MovieListVC?
    let load = NetworkModel()
    var _tableData:[Movie] = []
    
    var _page:Int = 0
    var _selectedMovie:Movie?
    var downloading = false
    var refresh:UIRefreshControl?
    var firstDispleyingPage:Int?
    var loading = false
    var sectionTitle:String?

    var beginScrollPosition:CGFloat = 0
    var stopDownloading = false
    var previousScrollPosition:CGFloat = 0
    var shakeHidden = false
    var screenType:ScreenType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(for: screenType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppeare()
    }
    
    override func firstLayoutSubviews() {
        if screenType == .search {
            self.searchBar.becomeFirstResponder()
        }
    }

    override func filterChanged() {
        super.filterChanged()
        self.collectionView.reloadData()
    }
    
    var tableData:[Movie] {
        get {
            return _tableData
        }
        set {
            _tableData = newValue
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if self.refresh?.isRefreshing ?? true {
                    self.refresh?.endRefreshing()
                }
            }
        }
    }
 
    var selectedMovie:Movie? {
        get { return _selectedMovie}
        set {
            _selectedMovie = newValue
            if newValue != nil {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toMovie", sender: self)
                    self.shakeButton.isEnabled = true
                }
            }
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toMovie":
            let vc = segue.destination as! MovieVC
            vc.movie = selectedMovie
            vc.favoritesPressedAction = screenType == .favorite ? loadFavorites : nil
            selectedMovie = nil
        default:
            break
        }
    }


    @IBAction func randomPressed(_ sender: Any) {
        getRandom()
    }
    


    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.searchBar.isFirstResponder {
            DispatchQueue.main.async {
                self.searchBar.endEditing(true)
            }
        }
    }

}



