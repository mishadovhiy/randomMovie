//
//  SwipeMovieVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit
import GoogleMobileAds

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
        self.index = 0
       DispatchQueue(label: "api", qos: .userInitiated).async {
           NetworkModel().openAIMovies { loadedData in
               self.allApi = [.init(movie: loadedData, page: 0)]
               self.randomList = loadedData
               if loadedData.isEmpty {
                   self.reloadedCount += 1
               } else {
                   self.reloadedCount = 0
               }
               DispatchQueue.main.async {
                   if loadedData.isEmpty && self.reloadedCount <= 10 {
                       self.apiLoad()
                       return
                   }
            self.setAnimating(animating: loadedData.count == 0, error: loadedData.count == 0 ? .init(title: "No data loaded from the server") : nil, completion: {
                                           if loadedData.count != 0 {
                                               self.loadMovies()
                                           }
                                       })
               }
           }
        }
    }
    var reloadedCount = 0
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        touched = false
    }
    
    var movieBoxes:(first:MoviePreviewView, second:MoviePreviewView?, third:MoviePreviewView?)?
    
    @IBAction func reloadPressed(_ sender: Any) {
        AppDelegate.shared?.banner.toggleFullScreenAdd(self, loaded: {
            AppDelegate.shared?.banner.interstitial = $0
            AppDelegate.shared?.banner.interstitial?.fullScreenContentDelegate = self
        }, closed: { presented in
            self.reloadPressed()
        })
        
    }
    
    
    
    func loadMovies() {
        if let first = createMovie(first: true) {
            moveNext(all: (first:first, second:createMovie(), third:createMovie()), firstLoad: true)
        } else {
            index = 0
            touched = false
            self.setAnimating(error: .init(title: "Movie list is Emty", description: ""))
            
//            reloadPressed()

//            DispatchQueue(label: "prepare", qos: .userInitiated).async {
//                let randoms = self.setRandoms()
//                DispatchQueue.main.async {
//                    if randoms {
//                        self.loadMovies()
//                    } else {
//                        print("movie list completed")
//                        self.setAnimating(error: .init(title: "Movie list is Emty", description: ""))
//                    }
//                }
//            }
        }
    }
    
    lazy var transform:(first:CGFloat, second:CGFloat) = {
        let selfAr = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) > 0
        return(first: selfAr ? 5 : 10,
               second: selfAr ? 10 : 20)
    }()
    
    func cardMovedToTop(card:MoviePreviewView, fixingViews:Bool = false, cardRemoved:Bool = false) {
        print(card, " gdfdssfgdhfn")
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
                LocalDB.db.favoritePressed(button: nil, canRemove: false, movie: card.vc?.movie)
            }
        }
    }
    
    
    ///todo: scroll on scrollView didScroll
    var scroll:TableScroll = .init()

}


extension SwipeMovieVC {
    class MoviePreviewView:TouchView {
        weak var vc:MovieVC?
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
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
    }
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    
    static func configure() -> SwipeMovieVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SwipeMovieVC") as! SwipeMovieVC
        return vc
    }
}

extension SwipeMovieVC:GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        AppDelegate.shared?.banner.adDidPresentFullScreenContent(ad)
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        AppDelegate.shared?.banner.adDidDismissFullScreenContent(ad)
    }
}
