//
//  LocalDB.swift
//  MovieList
//
//  Created by Misha Dovhiy on 06.05.2022.
//

import UIKit

struct LocalDB {
    static var dbHolder:DB?
    static var db:DB {
        get {
            if Thread.isMainThread {
                print("isMainThreaderror")
            }
            return .init(dict: UserDefaults.standard.value(forKey: "LocalDB") as? [String:Any] ?? [:])
        }
        set {
            if Thread.isMainThread {
                print("isMainThreaderror")
            }
            LocalDB.dbHolder = newValue
            UserDefaults.standard.setValue(newValue.dict, forKey: "LocalDB")
        }
    }
    
    
    struct DB {
        var dict:[String:Any]
        init(dict:[String:Any]) {
            self.dict = dict
        }
        
        
        
        var filter:Filter {
            get { return .init(dict: dict["Filter"] as? [String:Any] ?? [:]) }
            set {
                dict.updateValue(newValue.dict, forKey: "Filter")
            }
        }
        
        var favoriteMovieID: [String:Any] {
            get {
                return dict["favoriteMovie"] as? [String:Any] ?? [:]
            }
            set {
                dict.updateValue(newValue, forKey: "favoriteMovie")
            }
        }
        
        
        var folders: [Folder] {
            get {
                return (dict["folders"] as? [[String:Any]] ?? []).compactMap({
                    return .init(dict: $0)
                })
            }
            set {
                let dicts:[[String:Any]] = newValue.compactMap({
                    $0.dict})
                dict.updateValue(dicts, forKey: "folders")
            }
        }
        
        
        struct Folder {
            var dict:[String:Any]
            init(dict: [String : Any]) {
                self.dict = dict
            }
            init(id:Int, name:String) {
                dict = [:]
                self.id = id
                self.name = name
            }
            var movies:[Movie] {
                return LocalDB.db.favoriteMovies.filter({$0.folderID == self.id})
            }
            
            var id:Int {
                get {
                    return dict["id"] as? Int ?? -1
                }
                set {
                    dict.updateValue(newValue, forKey: "id")
                }
            }
            var name:String {
                get {
                    return dict["name"] as? String ?? ""
                }
                set {
                    dict.updateValue(newValue, forKey: "name")
                }
            }
        }
        
        func favoritePressed(button:UIButton?, canRemove:Bool = true, movie:Movie?, completion:((_ isFavorite:Bool)->())? = nil) {
            if let movie = movie {
                var movieFav:UIColor = Text.Colors.darkGrey
                var isFavorite = false
             //   DispatchQueue(label: "db", qos: .userInitiated).async {
                    if let _ = LocalDB.db.favoriteMovieID[movie.imdbid], canRemove {
                        LocalDB.db.favoriteMovieID.removeValue(forKey: movie.imdbid)
                    } else {
                        movieFav = .red
                        LocalDB.db.favoriteMovieID.updateValue(movie.dict, forKey: movie.imdbid)
                        isFavorite = true
                    }
                    DispatchQueue.main.async {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        button?.tintColor = movieFav
                        (button as? HeartButton)?.animateImage(like: isFavorite)

                    }
                    completion?(isFavorite)
                }
         //   }
        }
        
        var favoriteMovies: [Movie] {
            get {
                let movieListDB = dict["favoriteMovie"] as? [String:Any] ?? [:]

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
                dict.updateValue(newValue, forKey: "favoriteMovie")
            }
        }
        
        
        var mySqlMovieListUD: Data? {
            get {
                return dict["mySqlMovieList"] as? Data
            }
            set {
                if let dat = newValue {
                    dict.updateValue(dat, forKey: "mySqlMovieList")
                }
            }
        }
        
        
        
        var movieImages: [String:[String:Any]] {
            get {
                return dict["movieImages"] as? [String:[String:Any]] ?? [:]
            }
            set {
                dict.updateValue(newValue, forKey: "movieImages")
            }
        }
        
        
        var page:Int {
            get {
                return dict["page"] as? Int ?? 0
            }
            set {
                dict.updateValue(newValue, forKey: "page")
            }
        }
        
        var tomm:Int {
            get {
                return dict["tomm"] as? Int ?? 0
            }
            set {
                dict.updateValue(newValue, forKey: "tomm")
            }
        }
        
        
        func checkOldImgs() {
            let db = movieImages
            var res: [String:[String:Any]] = [:]
            db.forEach { (key: String, value: [String : Any]) in
                let dif = (value["date"] as? Date)?.differenceFromNow
                let bigger = ((dif?.year ?? 0) + (dif?.month ?? 0) + (dif?.day ?? 0 >= 15 ? 1 : 0)) >= 1
                if bigger {
                    res.removeValue(forKey: key)
                } else {
                    res.updateValue(value, forKey: key)
                }
            }

            LocalDB.db.movieImages = res

        }
    }
    
    
}


