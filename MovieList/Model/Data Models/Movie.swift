//
//  Movie.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class Movie {
    let name:String
    let imageURL:String
    let imdbid:String
    let imdbrating:Double
    let released:String
    let about:String
    let genre:[String]
    let dict:[String:Any]
    
    var image:Data?
    
    init(dict:[String:Any]) {
        self.name = dict["title"] as? String ?? ""
        let images = dict["imageurl"] as? [String] ?? []
        self.imageURL = images.first ?? ""
        self.imdbid = dict["imdbid"] as? String ?? ""
        self.imdbrating = dict["imdbrating"] as? Double ?? 0.0
        self.released = "\(dict["released"] as? Int ?? 0)"
        self.about = dict["synopsis"] as? String ?? ""
        self.genre = dict["genre"] as? [String] ?? []
        self.dict = dict
    }
    
    func filterValidation(imgOnly:Bool = false) -> Bool {
        if self.imageURL != "" {
            if imgOnly {
                return true
            } else {
                if self.validateRange(release: true) &&
                    self.validateRange(release: false) &&
                    self.validateGanre()
                {
                    return true
                } else {
                    return false
                }
            }
        } else {
            return false
        }
        
        
    }
    
    var type:MovieType {
        let str = self.dict["type"] as? String ?? ""
        switch str {
        case "movie": return .movie
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
    
    
    enum MovieType:String {
        case movie = "movie"
        case show = "show"
    }

    
    
    
    
    private func validateGanre() -> Bool {
        let ignoredList = LocalDB.Filter.ignoredGenres
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
    
    private func validateRange(release:Bool) -> Bool {
        if release {
            return inRange(min: LocalDB.Filter.yearRating.from, max: LocalDB.Filter.yearRating.to, value: self.released)
        } else {
            return inRange(min: LocalDB.Filter.imdbRating.from, max: LocalDB.Filter.imdbRating.to, value: "", doubleValue: self.imdbrating)
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
    
    
    
    
    
    var genreString:String {
        var result = ""
        for item in genre {
            result = result + " " + item
        }
        return result
    }

}


struct MovieList {
    let movie:[Movie]
    let page:Int
}
