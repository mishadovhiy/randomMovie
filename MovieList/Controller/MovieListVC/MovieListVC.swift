//
//  ViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class MovieListVC: BaseVC {
    typealias TransitionComponents = (albumCoverImageView: UIImageView?, albumNameLabel: UILabel?)
    public var transitionComponents = TransitionComponents(albumCoverImageView: nil, albumNameLabel: nil)
    private let transitionManager = AnimatedTransitioningManager(duration: 0.5)
    
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
    var selectedImageView:UIImageView?

    var selectedFolder:LocalDB.DB.Folder?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(for: screenType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppeare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (shakeButton as! LoadingButton).touch(false)
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
               /* DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toMovie", sender: self)
                    self.shakeButton.isEnabled = true
                }*/
                if let _ = selectedImageView {
                    self.navigationController?.delegate = transitionManager
                }
                MovieVC.present(movie: newValue, favoritesPressedAction: screenType == .favorite ? loadFavorites : nil, inVC: self)
                self.shakeButton.isEnabled = true
                (self.shakeButton as! LoadingButton).touch(false)
            }
        }
    }
    
    
    
    func createFolderPressed() {
        print("createFolderPressedcreateFolderPressed")
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let lastID = LocalDB.db.folders.sorted(by: {$0.id > $1.id}).first?.id
            print("lastID", lastID, " erfwdedwfergtvf")
            LocalDB.db.folders.append(.init(id: lastID ?? 0, name: "New Folder"))
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


extension MovieListVC {
    static func configure(type:ScreenType) -> MovieListVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieList") as! MovieListVC
        vc.screenType = type
        return vc
    }
}


