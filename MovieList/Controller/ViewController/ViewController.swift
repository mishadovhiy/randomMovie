//
//  ViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var sideBarPinchView: UIView!
    @IBOutlet weak var sideBarTable: UITableView!
    @IBOutlet weak var shakeButton: Button!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    static var shared:ViewController?
    let load = NetworkModel()
    var _tableData:[Movie] = []
    
    var page:Int = 0
    var downloading = false
    var refresh:UIRefreshControl?
    var firstDispleyingPage:Int?
    var loading = false
    
    //sideBar
    @IBOutlet weak var sideBar: SideBar!
    var sidescrolling = false
    var wasShowingSideBar = false
    var beginScrollPosition:CGFloat = 0
    var sideBarShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.shared = self

        sideBarPinchView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sideBarPinched(_:))))
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.doubleView()
        download()
        sideBar.load()
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
        self.page = calcPage <= 0 ? 0 : calcPage
        print(self.page, "pagepagepagepagepage")
        if firstDispleyingPage == nil {
            firstDispleyingPage = self.page
        }
        DispatchQueue.init(label: "download", qos: .userInitiated).async {
            self.load.getMovies(page: self.page) { movies, error in
                UserDefaults.standard.setValue(page, forKey: "page")
                DispatchQueue.main.async {
                    self.pageLabel.text = "\(self.page)"
                }
                var i = 0
                self.loading = false
                for movie in movies {
                    self.load.image(for: movie.imageURL) { data in
                        movie.image = data
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
        
    }
    

    @IBAction func randomPressed(_ sender: Any) {
        getRandom()
    }

    func getRandom() {
        load.getMovies(page: Int.random(in: 0..<load.maxPage)) { movies, error in
            if let random = movies.randomElement() {
                self.selectedMovie = random
            } else {
                self.getRandom()
            }
            
        }
    }
    
    
    @objc func refresh(sender:UIRefreshControl) {
        let new = (self.firstDispleyingPage ?? 0) - 20
        firstDispleyingPage = nil
        download(new)
    }
    
    var _selectedMovie:Movie?
    var selectedMovie:Movie? {
        get { return _selectedMovie}
        set {
            _selectedMovie = newValue
            if newValue != nil {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toMovie", sender: self)
                }
            }
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
    private func toggleShakeButton(hide:Bool) {
        if shakeHidden != hide {
            shakeHidden = hide
            DispatchQueue.main.async {
                let space = self.view.safeAreaInsets.top + self.shakeButton.frame.maxY + 50
                let position = hide ? (space * (-1)) : 0
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .allowAnimatedContent) {
                    self.shakeButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, position, 0)
                }
            }
        }
    }
    
}



