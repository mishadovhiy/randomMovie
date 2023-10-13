//
//  SwipeMovieVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit

class SwipeMovieVC: BaseVC {
    @IBOutlet weak var containerView: TouchView!
    @IBOutlet weak var loadingStack: UIStackView!
    @IBOutlet weak var reloadButton: UIButton!
    
    var index:Int = 0
    lazy var cardsGestureManager:ContainerPanGesture = .init(vc: self, delegate: self)
    var touched:Bool = false
    var allApi:[MovieList] = []
    var randomList:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiLoad()
    }
        
    
    
    override func filterChanged() {
        removeAllBoxes()
        reloadPressed()
    }
    
    func apiLoad() {
       //  tempAppearence()
       DispatchQueue(label: "api", qos: .userInitiated).async {
            NetworkModel().loadSQLMovies { loadedData, error in
                if Thread.isMainThread {
                    print("rgefdscfewr fataaal")
                    
                }
                self.allApi = loadedData
                DispatchQueue.main.async {
                    self.setAnimating(animating: loadedData.count == 0, error: loadedData.count == 0 ? .init(title: "No data loaded from the server") : nil, completion: {
                        if loadedData.count != 0 {
                            self.loadMovies()
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        touched = false
    }
    
    var movieBoxes:(first:MoviePreviewView, second:MoviePreviewView?, third:MoviePreviewView?)?
    
    @IBAction func reloadPressed(_ sender: Any) {
        reloadPressed()
    }
    
    func loadMovies() {
        if let first = createMovie(first: true) {
            moveNext(all: (first:first, second:createMovie(), third:createMovie()), firstLoad: true)
        } else {
            index = 0
            touched = false
            DispatchQueue(label: "prepare", qos: .userInitiated).async {
                let randoms = self.setRandoms()
                DispatchQueue.main.async {
                    if randoms {
                        self.loadMovies()
                    } else {
                        print("movie list completed")
                        self.setAnimating(error: .init(title: "Movie list is Emty", description: ""))
                    }
                }
            }
        }
    }
    
    lazy var transform:(first:CGFloat, second:CGFloat) = {
        let selfAr = (AppDelegate.shared?.window?.safeAreaInsets.bottom ?? 0) > 0
        return(first: selfAr ? 5 : 10,
               second: selfAr ? 10 : 20)
    }()
    
    func cardMovedToTop(card:MoviePreviewView, fixingViews:Bool = false, cardRemoved:Bool = false) {
        if fixingViews && !touched {
            UIView.animate(withDuration: 0.4) {
                self.containerView.alpha = 1
                self.containerView.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }
            
        }
        card.vc?.movedToTop = true
        card.vc?.containerAppeared()
    }
    
    func cardWillMove(for action:PanActionType, card: MoviePreviewView) {

    }
    
    func cardDidMove(for action:PanActionType, card:MoviePreviewView) {
        if action == .like {
            DispatchQueue(label: "db", qos: .userInitiated).async {
                LocalDB.db.favoritePressed(button: nil, movie: card.vc?.movie)
            }
        }
    }
    
    
    ///todo: scroll on scrollView didScroll
    var scroll:TableScroll = .init()

}


extension SwipeMovieVC {
    class MoviePreviewView:TouchView {
        var vc:MovieVC?
        var gesture:UIPanGestureRecognizer?
        lazy var defaultCenter:CGPoint = { return self.center }()
        var isFirst:Bool = false
        var likeView:MovieActionView?
        var dislikeView:MovieActionView?
        
        func moveToCenter() {
            self.center = defaultCenter
            
        }
        
    }
    
    struct TableScroll {
        var active = false
        var startPositionY:CGFloat = 0
        var toHide:Bool = false
        var isDeclaring = false
        var endedNavAnimation = false
        var positionY:CGFloat = 0
        var canChange:Bool = false
        var scrollingTop:CGFloat = 0
    }
}


extension SwipeMovieVC {
    static func configure() -> SwipeMovieVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SwipeMovieVC") as! SwipeMovieVC
        return vc
    }
}
