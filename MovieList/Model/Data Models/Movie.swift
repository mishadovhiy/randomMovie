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

class Movie:Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.imdbid == rhs.imdbid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(imageURL)
        hasher.combine(imdbid)
        hasher.combine(imdbrating)
        hasher.combine(released)
        hasher.combine(about)
        hasher.combine(genre)
        hasher.combine(folderID)
        hasher.combine(image)
        hasher.combine(isFolder)
    }
    
    var name:String
    var imageURL:String
    var imdbid:String
    var imdbrating:Double
    let released:String
    var about:String
    let genre:[String] 
    var dict:[String:Any]
    var folderID:Int? {
        get {
            return Int(dict["folderID"] as? String ?? "")
        }
        set {
            if let newValue {
                dict.updateValue("\(newValue)", forKey: "folderID")
            } else {
                dict.removeValue(forKey: "folderID")
            }
        }
    }
    var image:Data?
    var isFolder:Bool {
        get {
            return dict["isFolder"] as? String == "1"
        }
        set {
            dict.updateValue(newValue ? "1" : "0", forKey: "isFolder")
        }
    }
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
    
    init(folder:LocalDB.DB.Folder) {
        let dict = folder.dict
        self.name = dict["name"] as? String ?? ""
        self.imageURL = ""
        self.imdbid = ""
        self.imdbrating = 0
        self.released = ""
        self.about = ""
        self.genre = []
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
    static func configure(_ response:Unparce.OpenAIMovieResponse.MovieList) -> Movie {
        .with {
            $0.imdbid = response.imdbid ?? ""
            $0.about = response.description ?? ""
            $0.imdbrating = Double(response.imdbrating ?? 0) ?? 0
            $0.name = response.movieName ?? ""
            $0.imageURL = response.imageURL ?? ""
        }
    }
    
    public static func with(
        _ populator: (inout Movie) throws -> ()
    ) rethrows -> Movie {
        var message = Movie(dict: [:])
        try populator(&message)
        return message
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

