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
    private let transitionManager = AnimatedTransitioningManager(duration: 0.3)
    
    @IBOutlet weak var deleteFolderButton: UIButton!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var shakeButton: Button!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    var dragIndex:IndexPath?
    var reloadAction:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(for: screenType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppeare()
        navigationController?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (shakeButton as! LoadingButton).touch(false)
        if screenType == .favorite {
            self.navigationController?.setNavigationBarHidden(false, animated: true)

        }
    }
        
    override func dataBaseUpdated() {
        super.dataBaseUpdated()
        updateUI(for: screenType)
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
    
    var folders:[LocalDB.DB.Folder] = []
    
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
                (TabBarVC.shared?.navigationController)!.delegate = transitionManager
                if selectedImageView == nil {
                    selectedImageView = .init()
                    selectedImageView?.frame = .init(origin: .init(x: view.frame.width, y: shakeButton.frame.minY - 40), size: .init(width: collectionCellWidth, height: 180))
                    selectedImageView?.image = .init(data: NetworkModel().localImage(url: newValue?.imageURL ?? "", fromHolder: true) ?? .init())
                }
                MovieVC.present(movie: newValue, favoritesPressedAction: screenType == .favorite ? {
                    self.updateData = true
                } : nil, inVC: self, fromTransaction: transitionManager)
                self.shakeButton.isEnabled = true
                (self.shakeButton as! LoadingButton).touch(false)
            }
        }
    }
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if selectedFolder != nil {
            view.endEditing(true)
            collectionView.reloadData()
        }
    }
    
    
    func createFolderPressed() {
        print("createFolderPressedcreateFolderPressed")
        self.vibrate(style: .light)
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let lastID = LocalDB.db.folders.sorted(by: {$0.id > $1.id}).first?.id ?? 0
            print("lastID", lastID, " erfwdedwfergtvf")
            LocalDB.db.folders.append(.init(id: lastID + 1))
            self.folders = LocalDB.db.folders
            DispatchQueue.main.async {
                self.collectionView.reloadData()
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

    @IBAction func deleteFolderPressed(_ sender: UIButton) {
        reloadAction?()
        sender.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            sender.alpha = 0
        }) { _ in
            sender.removeFromSuperview()
        }
        DispatchQueue(label: "db", qos: .userInitiated).async {
            LocalDB.db.folders.removeAll {
                $0.id == self.selectedFolder?.id
            }
            let movies = LocalDB.db.favoriteMovies.filter({ $0.folderID == self.selectedFolder?.id })
            movies.forEach {
                $0.folderID = nil
            }
            LocalDB.db.favoriteMovies.removeAll(where: {$0.folderID == self.selectedFolder?.id})
            movies.forEach {
                LocalDB.db.favoriteMovies.append($0)
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    

    @IBAction func randomPressed(_ sender: Any) {
        selectedImageView = nil
        getRandom()
    }
    

    func folderNameChanged(_ newValue:String) {
        guard let selected = selectedFolder else {
            return
        }
        reloadAction?()
        var selectedValue = selected
        selectedValue.name = newValue
        selectedFolder?.name = newValue
        DispatchQueue(label: "db", qos: .userInitiated).async {
            LocalDB.db.folders.removeAll {
                $0.id == selectedValue.id
            }
            LocalDB.db.folders.append(selectedValue)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.searchBar.isFirstResponder {
            DispatchQueue.main.async {
                self.searchBar.endEditing(true)
            }
        }
    }

}

//scroll view
extension MovieListVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newPosition = scrollView.contentOffset.y
        if newPosition <= 5 {
            toggleShakeButton(hide: false)
        } else {
            let scrollTop = newPosition > previousScrollPosition
            if scrollTop {
                toggleShakeButton(hide: scrollTop)
                
            } else {
                if newPosition < (previousScrollPosition + 100) {
                    toggleShakeButton(hide: scrollTop)
                }
            }
        }
        
    }
    

    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let newPosition = scrollView.contentOffset.y
        previousScrollPosition = newPosition
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newPosition = scrollView.contentOffset.y
        previousScrollPosition = newPosition
    }
}

extension MovieListVC {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
    }
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    static func configure(type:ScreenType, folder:LocalDB.DB.Folder? = nil, reloadAction:(()->())? = nil) -> MovieListVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieList") as! MovieListVC
        vc.screenType = type
        vc.selectedFolder = folder
        vc.reloadAction = reloadAction
        return vc
    }
}


