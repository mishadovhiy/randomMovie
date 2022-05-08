//
//  LocalDB.swift
//  MovieList
//
//  Created by Misha Dovhiy on 06.05.2022.
//

import UIKit

struct LocalDB {
    
    static var dictionary:[String:Any] {
        get {
            return UserDefaults.standard.value(forKey: "LocalDB") as? [String:Any] ?? [:]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "LocalDB")
        }
    }
    
    static var movieImages: [String:Data?] {
        get {
            UserDefaults.standard.value(forKey: "movieImages") as? [String:Data?] ?? [:]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "movieImages")
        }
    }
    
    static var favoriteMovieID: [String:Any] {
        get {
            return UserDefaults.standard.value(forKey: "favoriteMovie") as? [String:Any] ?? [:]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "favoriteMovie")
        }
    }
    static var favoriteMovies: [Movie] {
        get {
            let movieListDB = UserDefaults.standard.value(forKey: "favoriteMovie") as? [String:Any] ?? [:]
            var result:[Movie] = []
            for (key, movieAny) in movieListDB {
                if let movie = movieAny as? [String:Any] {
                    result.append(.init(dict: movie))
                }
            }
            return result
        }
        set {
            var result:[String:Any] = [:]
            for movie in newValue {
                result.updateValue(movie.dict, forKey: movie.imdbid)
            }
            UserDefaults.standard.setValue(result, forKey: "favoriteMovie")
        }
    }
    
    
    static var mySqlMovieListUD: Data? {
        get {
            return UserDefaults.standard.value(forKey: "mySqlMovieList") as? Data
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "mySqlMovieList")
        }
    }
}




//filter
extension LocalDB {
    struct Filter {
        static var dictionary:[String:Any] {
            get {
                return LocalDB.dictionary["Filter"] as? [String:Any] ?? [:]
            }
            set {
                LocalDB.dictionary.updateValue(newValue, forKey: "Filter")
            }
        }
        
        static var imdbRating:Rating {
            get {
                let imdb = LocalDB.Filter.dictionary["imdb"] as? [String:String] ?? [:]
                let from = Double.init(imdb["from"] ?? "4") ?? 0.0
                let to = Double.init(imdb["to"] ?? "10") ?? 0.0
                return .init(from: from,
                             to: to)
            }
            set {
                let new = [
                    "from":"\(newValue.from)",
                    "to":"\(newValue.to)",
                ]
                LocalDB.Filter.dictionary.updateValue(new, forKey: "imdb")
            }
        }

        
        
        static var yearRating:Rating {
            get {
                let year = LocalDB.Filter.dictionary["year"] as? [String:String] ?? [:]
                return .init(from: Double.init(year["from"] ?? "1980") ?? 0.0,
                             to: Double.init(year["to"] ?? ("\(Date().components.year ?? 2020)")) ?? 0.0)
            }
            set {
                let new = [
                    "from":String.init(decimalsCount: 3, from: newValue.from),
                    "to":String.init(decimalsCount: 3, from: newValue.to)
                ]
                LocalDB.Filter.dictionary.updateValue(new, forKey: "year")
            }
        }
        
        static var allGenres = ["Horror", "Comedy", "Drama", "Romance", "Sci-Fi", "Thriller", "Action", "Fantasy", "History", "Biography", "War", "Sport", "Adventure", "Crime", "Mystery", "Family", "Animation", "Music", "Musical", "Adult", "Western", "Documentary"]
        static var ignoredGenres:[String:Bool] {
            get {
                return LocalDB.Filter.dictionary["ignoredGenres"] as? [String:Bool] ?? [:]
            }
            set {
                LocalDB.Filter.dictionary.updateValue(newValue, forKey: "ignoredGenres")
            }
        }
        
        struct Rating {
            let from:Double
            let to:Double
        }
        
    }
}
