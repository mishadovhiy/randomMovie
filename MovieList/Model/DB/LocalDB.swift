//
//  LocalDB.swift
//  MovieList
//
//  Created by Misha Dovhiy on 06.05.2022.
//

import UIKit

struct LocalDB {
    static var db:DB {
        get {
            return .init(dict: UserDefaults.standard.value(forKey: "LocalDB") as? [String:Any] ?? [:])
        }
        set {
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
                }
            }

            UserDefaults.standard.setValue(res, forKey: "movieImages")
        }
    }
    
    
}

