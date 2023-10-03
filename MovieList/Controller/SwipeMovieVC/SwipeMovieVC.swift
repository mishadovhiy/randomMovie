//
//  SwipeMovieVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit

class SwipeMovieVC: BaseVC {
    @IBOutlet weak var containerView: TouchView!
    var data:[String] = ["fwe", "ew", "sfdfsd", "sfgda", "wre", "thrg", "hyrgt", "yh5trg", "njyhtbg", "ew", "sfdfsd", "sfgda", "wre", "thrg", "hyrgt", "yh5trg", "njyhtbg"]
    var index:Int = 0
    lazy var cardsGestureManager:ContainerPanGesture = .init(vc: self, delegate: self)
    var touched:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        touched = false
    }
    
    var movieBoxes:(first:MoviePreviewView, second:MoviePreviewView?, third:MoviePreviewView?)?
    
    func loadMovies() {
        if let first = createMovie() {
            moveNext(all: (first:first, second:createMovie(), third:createMovie()), firstLoad: true)
        } else {
            print("fetching new data")
            index = 0
            touched = false
            data = [
                "ew", "sfdfsd", "sfgda", "wre", "thrg", "hyrgt", "yh5trg", "njyhtbg"
            ]
            self.loadMovies()
            //load from api
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
        
    }
}


extension SwipeMovieVC {
    class MoviePreviewView:TouchView {
        var vc:MovieVC?
        var gesture:UIPanGestureRecognizer?
        lazy var defaultCenter:CGPoint = { return self.center }()

        func moveToCenter() {
            print("moveToCentermoveToCenter")
            self.center = defaultCenter
        }
    }
}


extension SwipeMovieVC {
    static func configure() -> SwipeMovieVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SwipeMovieVC") as! SwipeMovieVC
        return vc
    }
}
