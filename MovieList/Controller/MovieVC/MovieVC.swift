//
//  MovieVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

class MovieVC: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var additionalLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heartButton: Button!
    
    var movie:Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let load = NetworkModel()
        if let movie = movie {
            textView.text = movie.about
            additionalLabel.text = tempDescr(movie)
            nameLabel.text = movie.name
            if let _ = LocalDB.favoriteMovieID[movie.imdbid] {
                self.heartButton.tintColor = .red
            }
            DispatchQueue.init(label: "load", qos: .userInitiated).async {
                load.image(for: movie.imageURL, completion: { data in
                    if let imageData = data {
                        DispatchQueue.main.async {
                            self.movieImage.image = UIImage(data: imageData)
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func imdbPressed(_ sender: UIButton) {
        guard let movie = movie else {
            print("error")
            return
        }
        if movie.imdbid != "" {
            let str = "https://www.imdb.com/title/\(movie.imdbid)/"
            guard let url = URL(string: str) else {
                print("error")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:]) { _ in
                    
                }
            }
        }
    }
    
    func tempDescr(_ movie:Movie) -> String {
        return "Genres: \(tempArrey(movie.genre))\n" + "imdb: \(movie.imdbrating)\n" + "relaesed: \(movie.released)\n"
    }
    
    
    private func tempArrey(_ arrey:[String]) -> String {
        var result:String = ""
        for ar in arrey {
            let new = ar + ", "
            result += new
        }
        return result
    }

    @IBAction func favoritesPressed(_ sender: UIButton) {
        if let movie = movie {
            var movieFav:UIColor = .systemGray
            if let _ = LocalDB.favoriteMovieID[movie.imdbid] {
                LocalDB.favoriteMovieID.removeValue(forKey: movie.imdbid)
            } else {
                movieFav = .red
                LocalDB.favoriteMovieID.updateValue(movie.dict, forKey: movie.imdbid)
            }
            DispatchQueue.main.async {
                self.heartButton.tintColor = movieFav
            }
        }
    }
}
