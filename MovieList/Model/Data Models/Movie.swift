//
//  Movie.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

struct MovieList {
    let movie:[Movie]
    let page:Int
    
    var randomMovie: Movie? {
        return movie.randomElement()
    }
}

class Movie {
    let name:String
    let imageURL:String
    let imdbid:String
    let imdbrating:Double
    let released:String
    let about:String
    let genre:[String]
    let dict:[String:Any]
    var folderID:Int?
    var image:Data?
    var isFolder:Bool
    init(dict:[String:Any]) {
        self.name = dict["title"] as? String ?? ""
        let images = dict["imageurl"] as? [String] ?? []
        self.imageURL = images.first ?? ""
        self.imdbid = dict["imdbid"] as? String ?? ""
        self.imdbrating = dict["imdbrating"] as? Double ?? 0.0
        self.released = "\(dict["released"] as? Int ?? 0)"
        self.about = dict["synopsis"] as? String ?? ""
        self.genre = dict["genre"] as? [String] ?? []
        self.folderID = dict["folderID"] as? Int
        self.isFolder = dict["isFolder"] as? Bool ?? false
        self.dict = dict
    }
    
    init(folder:LocalDB.DB.Folder) {
        let dict = folder.dict
        self.name = dict["name"] as? String ?? ""
        self.imageURL = ""
        self.imdbid = ""
        self.imdbrating = 0
        self.released = ""
        self.about = ""
        self.genre = []
        self.folderID = dict["id"] as? Int
        self.isFolder = true
        self.dict = folder.dict
    }
    
    var type:MovieType {
        let str = self.dict["type"] as? String ?? ""
        switch str {
        case "movie":
            return .movie
        case "show", "tvSeries", "tvMiniSeries":
            return .show
        default:
            return .movie
        }
    }
    
    var description:String {
        var result = ""
        var i = 0
        let di = dict.sorted( by: { $0.0 < $1.0 })
        for (key, value) in di {
            let val = value as? String ?? "\(value as? Int ?? -2)"
            let new = "\(i). " + key + ": " + (val) + "\n"
            i += 1
            result += new
        }
        return result
    }
    
    var genreString:String {
        var result = ""
        for item in genre {
            result = result + " " + item
        }
        return result
    }

    
    
    func filterValidation(imgOnly:Bool = false) -> Bool {
        if self.imageURL != "" {
            return imgOnly ? true : self.validate()
        } else {
            return false
        }
    }
    
    
    
    enum MovieType:String {
        case movie = "movie"
        case show = "show"
    }
}





extension Movie {
    func validate() -> Bool {
        return self.validateRange(.year) && self.validateRange(.imdb) && self.validateGanre()
    }

    
    
    private func validateGanre() -> Bool {
        let ignoredList = LocalDB.db.filter.ignoredGenres
        var result = false
        let movieGanres = self.genre
        for i in 0..<movieGanres.count {
            let ignored = ignoredList[movieGanres[i]] ?? false
            if !ignored {
                result = true
            }
        }
        return result
    }
    
    private func validateRange(_ type:RangeType) -> Bool {
        switch type {
        case .imdb:
            return inRange(min: LocalDB.db.filter.imdbRating.from, max: LocalDB.db.filter.imdbRating.to, value: "", doubleValue: self.imdbrating)
        case .year:
            return inRange(min: LocalDB.db.filter.yearRating.from, max: LocalDB.db.filter.yearRating.to, value: self.released)
        }
    }
    
    private func inRange(min:Double, max:Double, value:String, doubleValue:Double = 0) -> Bool {
        if min < max {
            let numberRange = (min - 0.01)...(max + 0.01)
            let selfNumber = Double(value) ?? doubleValue
            return numberRange.contains(selfNumber) ? true : false
        } else {
            return true
        }
        
    }

    
    
    private enum RangeType {
        case imdb
        case year
    }
}

