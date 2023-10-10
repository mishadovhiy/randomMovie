//
//  MovieVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

class MovieVC: BaseVC {

    typealias TransitionComponents = (albumCoverImageView: UIImageView?, albumNameLabel: UILabel?)

    public var transitionComponents = TransitionComponents(albumCoverImageView: nil, albumNameLabel: nil)

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var additionalLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heartButton: HeartButton!
    
    var container:SwipeMovieVC.MoviePreviewView?
    var movie:Movie?
    var favoritesPressedAction:(() -> ())?
    
    private var favoriteChanged = false
    private let transitionManager = TransitionManager(duration: 0.5)

    override func viewDidLoad() {
        super.viewDidLoad()
      //  navigationController?.delegate = self
        loadData()
        if isPreview {
            self.view.layer.cornerRadius = Styles.buttonRadius3
            self.view.layer.masksToBounds = true
        }
        movieImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgPressed(_:))))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if favoriteChanged {
            if let action = favoritesPressedAction {
                action()
            }
        }
    }
    
    @objc func imgPressed(_ sender:UITapGestureRecognizer) {
        let sup = (movieImage.superview as? UIStackView)?.frame ?? .zero
        //    .init(x: 20, y: 88)
        let hasContainer = (TabBarVC.shared?.segmented?.frame.height ?? 0) - 9
        let xContainer = sup.minX + (container?.frame.minX ?? 0) + 13.2

        let top = container != nil ? hasContainer : (-15)
        if let vc = ImageVC.configure(img: movie?.image, from: movieImage.frame, fromAdditional: .init(x: xContainer, y: top + sup.minY), animateBack: container != nil) {
            self.push(vc: vc)
        }
      //  ImageVC.present(img: movie?.image, from: movieImage.frame, inVC: self, fromAdditional: .init(x: xContainer, y: top + sup.minY), animateBack: container != nil)
    }
    
    func loadData() {
        let load = NetworkModel()
        if let movie = movie {
            textView.text = movie.about
            additionalLabel.text = tempDescr(movie)
            nameLabel.text = movie.name
            if let _ = LocalDB.db.favoriteMovieID[movie.imdbid] {
                self.heartButton.tintColor = .red
            }
            DispatchQueue.init(label: "load", qos: .userInitiated).async {
                load.image(for: movie.imageURL, completion: { data in
                    if let imageData = data,
                       let image = UIImage(data: imageData) {
                        self.movie?.image = imageData
                        DispatchQueue.main.async {
                            self.movieImage.image = image
                        }
                    }
                })
            }
        }
    }
    
    func tempDescr(_ movie:Movie) -> String {
        return "Genres: \(tempArrey(movie.genre))\n" + "imdb: \(movie.imdbrating)\n" + "relaesed: \(movie.released)\n"
    }
    
    
    private func tempArrey(_ arrey:[String]) -> String {
        var result:String = ""
        for ar in arrey {
            let comma = ar != arrey.last ? ", " : ""
            let new = ar + comma
            result += new
        }
        return result
    }

    
    
    @IBAction func favoritesPressed(_ sender: UIButton) {
        favoriteChanged = true
        LocalDB.db.favoritePressed(button: sender, movie: movie)
    }
    
    
    @IBAction func imdbPressed(_ sender: UIButton) {
        let errorActions = {
            DispatchQueue.main.async {
                self.message.show(title:"URL not found", type: .error)
            }
        }
        guard let movie = movie else {
            errorActions()
            return
        }
        if movie.imdbid != "" {
            let str = "https://www.imdb.com/title/\(movie.imdbid)/"
            guard let url = URL(string: str) else {
                errorActions()
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:]) { _ in
                    
                }
            }
        } else {
            errorActions()
        }
    }
    var isPreview:Bool = false
    var movedToTop:Bool = false
    func containerAppeared() {
        
    }

    func updateScroll(scrValue:CGFloat, topValue:CGFloat, action:PanActionType?) {
        let actionView = actionView(type: action)
        let views = [container?.dislikeView, container?.likeView]
        print(scrValue, " scrValuescrValuescrValue")
        let value:CGFloat = action == nil ? 0 : scrValue
        views.forEach({
            let selected = actionView == $0
            print(selected, " bgrtfec")
            $0?.pressed(percent: selected ? value : 0)
        })
    }
    
    func actionView(type:PanActionType?) -> MovieActionView? {
        switch type {
        case .dislike:
            return container?.dislikeView
        case .like:
            return container?.likeView
        default:
            return nil
        }
    }
    
    var isHapptic:Bool = false
    func happtic(start:Bool) {
        
    }
    
    
    
    func push(vc:UIViewController) {
        navigationController?.delegate = transitionManager
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TransitionManager:UINavigationControllerDelegate {
    func navigationController(
            _ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
            from fromVC: UIViewController,
            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
                return self
        }
}

extension MovieVC {
    static func configure(isPreview:Bool = false, movie:Movie? = nil, favoritesPressedAction:(() -> ())? = nil) -> MovieVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieVC") as! MovieVC
        vc.isPreview = isPreview
        vc.movie = movie
        vc.favoritesPressedAction = favoritesPressedAction
        return vc
    }
}
