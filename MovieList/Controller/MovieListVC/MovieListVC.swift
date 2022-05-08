//
//  ViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class MovieListVC: UIViewController {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var shakeButton: Button!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    //sideBar
    @IBOutlet weak var sideBar: SideBar!
    @IBOutlet weak var sideBarPinchView: UIView!
    @IBOutlet weak var sideBarTable: UITableView!
    var sidescrolling = false
    var wasShowingSideBar = false
    var beginScrollPosition:CGFloat = 0
    var sideBarShowing = false
    var stopDownloading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(for: screenType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sideBar.getData()
    }
    
    private var subviewsLayoued = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !subviewsLayoued {
            subviewsLayoued = true
            refresh = UIRefreshControl.init(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 30))
            collectionView.addSubview(refresh ?? UIRefreshControl.init(frame: .zero))
            refresh?.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        }
        
    }
    
    
    func updateUI(for type: ScreenType) {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.doubleView()
        
        switch type {
        case .all:
            sectionTitle = "Movie List"
            MovieListVC.shared = self
            sideBarPinchView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sideBarPinched(_:))))
            sideBar.load()
            
        case .favorite:
            sectionTitle = "Favorites"
            self.tableData = LocalDB.favoriteMovies
            self.pinchIndicatorStack.isHidden = true
        }
    }
    
    
    @IBOutlet weak var pinchIndicatorStack: UIStackView!
    
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
    
    
    func download(_ page:Int? = nil) {
        if loading {
            return
        }
        loading = true
        let bigger = ((self.page > (page ?? 0)) && (page != nil)) ? false : true
        if !bigger {
            self.tableData = []
        }

        let calcPage = page ?? (UserDefaults.standard.value(forKey: "page") as? Int ?? 1)
        let loadingPage = calcPage <= 0 || calcPage >= (self.load.maxPage + 10) ? 0 : calcPage
        
        print(self.page, "pagepagepagepagepage")
        if firstDispleyingPage == nil || self.page == 0 {
            firstDispleyingPage = self.page
        }
        DispatchQueue.init(label: "download", qos: .userInitiated).async {
            if self.tableData.count > 1000 {
                self.tableData.removeSubrange(0..<850)
            }
            self.load.getMovies(page: loadingPage) { movies, error, newPage in
                print(error, " errorrrr")
                if error && (movies.count == 0) {
                    print("Error and no loaded movies")
                }
                if ((newPage + 1) >= self.load.moviesCount) || (loadingPage > newPage) {
                    self.stopDownloading = true
                }
                if self.tableData.count < 40 && movies.count < 40 {
                    self.tableData.removeAll()
                }
                self.page = newPage
                self.loading = false
                for movie in movies {
                    self.load.image(for: movie.imageURL) { data in
                        movie.image = data
                        self.tableData.append(movie)
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    if self.refresh?.isRefreshing ?? true {
                        self.refresh?.endRefreshing()
                    }
                }
            }
        }
        
    }
    
    var _moviesWithoutIMG:[Movie] = []
    var moviesWithoutIMG:[Movie] {
        get {
            return _moviesWithoutIMG
        }
        set {
            
            for movie in newValue {
                self.load.image(for: movie.imageURL) { data in
                    movie.image = data
                    self.tableData.append(movie)
                }

            }
        }
    }

    func prepareTableData(loadedCount:Int?) -> [Movie] {
        print(#function)
        let data = tableData
        var result:[Movie] = []
        if let loadedCount = loadedCount {
            if loadedCount < 40 && data.count < 40 {
                return []
            } else {
                return data
            }
        } else {
            if data.count >= 1000 {
                for i in 0..<data.count {
                    if i > 850 {
                        result.append(data[i])
                    }
                }
                return result
            } else {
                return data
            }
        }
    }
    
    
    @IBAction func randomPressed(_ sender: Any) {
        shakeButton.isEnabled = false
        getRandom()
    }

    func getRandom() {
        switch screenType {
        case .favorite:
            let movies = LocalDB.favoriteMovies
            if let random = movies.randomElement() {
                self.selectedMovie = random
            } else {
                DispatchQueue.main.async {
                    self.shakeButton.isEnabled = true
                }
            }
            
        case .all:
            DispatchQueue.init(label: "download", qos: .userInitiated).async {
                self.load.getMovies(page: Int.random(in: 0..<self.load.maxPage)) { movies, error, newPage  in
                    if let random = movies.randomElement() {
                        self.selectedMovie = random
                    } else {
                        self.getRandom()
                    }
                }
            }
            
        }
        
    }
    
    
    @objc func refresh(sender:UIRefreshControl) {
        let new = (self.firstDispleyingPage ?? 0) - 20
        firstDispleyingPage = nil
        download(new)
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
    
    
    
    
    
    
    var page:Int {
        get {
            return _page
        }
        set {
            _page = newValue
            UserDefaults.standard.setValue(newValue, forKey: "page")
            print("newPage: ", newValue)
        }
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sideBarShowing {
            self.toggleSideBar(false, animated: true)
        }
        switch segue.identifier {
        case "toMovie":
            let vc = segue.destination as! MovieVC
            vc.movie = selectedMovie
            selectedMovie = nil
        default:
            break
        }
    }

    
    var previousScrollPosition:CGFloat = 0
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
    
    
    var shakeHidden = false
    
    
    var screenType:ScreenType = .all
    enum ScreenType {
        case all
        case favorite
    }
    
    
    
    
    @IBAction func favoritesPressed(_ sender: Button) {
        DispatchQueue.main.async {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MovieList") as! MovieListVC
            vc.screenType = .favorite
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
            
            if self.sideBarShowing {
                self.toggleSideBar(false, animated: true)
            }
            
        }
    }
    
    
    
    
    
    
    func toggleShakeButton(hide:Bool) {
        if shakeHidden != hide {
            shakeHidden = hide
            DispatchQueue.main.async {
                let space = self.view.safeAreaInsets.top + self.shakeButton.frame.maxY + 50
                let position = hide ? (space * (-1)) : 0
                if !hide && !self.sideBarShowing {
                    self.pinchIndicatorStack.alpha = 1
                }
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .allowAnimatedContent) {
                    self.shakeButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, position, 0)
                    if !self.sideBarShowing {
                        self.pinchIndicatorStack.layer.transform = CATransform3DTranslate(CATransform3DIdentity, hide ? -(self.sideBar.frame.width + 20) : 0, 0, 0)
                    }
                    
                } completion: { _ in
                }

            }
        }
    }
    
}



