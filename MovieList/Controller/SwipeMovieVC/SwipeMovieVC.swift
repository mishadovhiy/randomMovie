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
    
    func setRandoms() -> Bool {
        print("setRandomssetRandomssetRandoms")
        randomList.removeAll()
        var data:[Int: [Movie]] = [:]
        for _ in 0..<20 {
            if let randomPage = allApi.randomElement()?.page {
                var newMovies = self.randomMovies(page: randomPage)

                if let updating = data[randomPage] {
                    updating.forEach({newMovies.append($0)})
                }
                data.updateValue(newMovies, forKey: randomPage)

            }
        }
        
        var c = 0
        let api = Array(allApi)
        data.forEach({ list in
            var new = api.first(where: {$0.page == list.key})?.movie ?? []
            print(new.count, " gterfwds")
            new.removeAll(where: { rem in
                return list.value.contains(where: {$0.imdbid == rem.imdbid})
            })
            print(new.count, " gterfwdsafterrrr")
            list.value.forEach({ _ in
                c += 1
            })
            allApi.removeAll(where: {$0.page == list.key})
            allApi.append(.init(movie: new, page: list.key))
        })
        data.forEach({ dict in
            dict.value.forEach({
                self.randomList.append($0)
            })
        })
        
        print(c, " brtgerfrvrgb")
        return !(randomList.count == 0)
    }

    private func randomMovies(page: Int) -> [Movie] {
        var newData:[Movie] = []
        for _ in 0..<(Int.random(in: 2...5)) {
            if let new = (allApi.first(where: {$0.page == page}))?.movie.randomElement() {
                newData.append(new)
                
            }
        }
        return newData
    }
    
    func apiLoad() {
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
    
    func setAnimating(animating:Bool = false, error:MessageContent? = nil, completion:(()->())? = nil) {
        let showStack = animating || error != nil
        let showButton = error != nil
        if self.loadingStack.isHidden != !showStack || reloadButton.isHidden != !showButton {
            let errorTitleLabel =                 self.loadingStack.arrangedSubviews.first(where: {$0 is UILabel && $0.tag == 0}) as? UILabel
            let errorDescriptionLabel =                 self.loadingStack.arrangedSubviews.first(where: {$0 is UILabel && $0.tag == 1}) as? UILabel
            let aiView = self.loadingStack.arrangedSubviews.first(where: {$0 is UIActivityIndicatorView}) as? UIActivityIndicatorView
            var animateButton:Bool = false
            let toHideButton = self.view.safeAreaInsets.bottom + self.reloadButton.frame.height + 20

            if showButton {
                errorTitleLabel?.text = error?.title
                errorDescriptionLabel?.text = error?.description
                reloadButton.isHidden = false
                self.reloadButton.layer.move(.top, value: toHideButton)
                animateButton = true
            }
            let alphaStack:CGFloat = showStack ? 1 : 0
            UIView.animate(withDuration: 0.3, animations: {
                if self.loadingStack.alpha != alphaStack {
                    self.loadingStack.alpha = alphaStack
                }
                if errorTitleLabel?.isHidden != !showButton {
                    errorTitleLabel?.isHidden = !showButton
                }
                if errorDescriptionLabel?.isHidden != !showButton {
                    errorDescriptionLabel?.isHidden = !showButton
                }

                aiView?.setAnimating = animating
                if self.reloadButton.isHidden != !showButton || animateButton {
                    self.reloadButton.layer.move(.top, value: showButton ? 0 : toHideButton)
                }
            }, completion: { _ in
                completion?()
                if self.reloadButton.isHidden != !showButton {
                    self.reloadButton.isHidden = !showButton
                }
            })
        } else {
            completion?()
        }
    }
    
    
    @IBAction func reloadPressed(_ sender: Any) {
        self.setAnimating(animating: true) {
            self.apiLoad()
        }
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
        
    }
}


extension SwipeMovieVC {
    class MoviePreviewView:TouchView {
        var vc:MovieVC?
        var gesture:UIPanGestureRecognizer?
        lazy var defaultCenter:CGPoint = { return self.center }()
        var isFirst:Bool = false
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
