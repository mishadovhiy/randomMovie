//
//  MovieVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

class MovieVC: BaseVC {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var additionalLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heartButton: Button!
    
    var movie:Movie?
    var favoritesPressedAction:(() -> ())?
    
    private var favoriteChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        if isPreview {
            self.view.layer.cornerRadius = 12
            self.view.layer.masksToBounds = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if favoriteChanged {
            if let action = favoritesPressedAction {
                action()
            }
        }
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
        if let movie = movie {
            var movieFav:UIColor = Text.Colors.darkGrey
            if let _ = LocalDB.db.favoriteMovieID[movie.imdbid] {
                LocalDB.db.favoriteMovieID.removeValue(forKey: movie.imdbid)
            } else {
                movieFav = .red
                LocalDB.db.favoriteMovieID.updateValue(movie.dict, forKey: movie.imdbid)
            }
            DispatchQueue.main.async {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                self.heartButton.tintColor = movieFav
            }
        }
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
        
    }
    
    var isHapptic:Bool = false
    func happtic(start:Bool) {
        
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
