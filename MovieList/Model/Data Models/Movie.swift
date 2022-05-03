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
        self.name = dict["title"] as? String ?? "-"
        let images = dict["imageurl"] as? [String] ?? []
        print(images, "imagesimagesimagesimages")
        print(images.first ?? "", "images.first images.first images.firstimages.firstimages.first")
        self.imageURL = images.first ?? ""
        self.imdbid = dict["imdbid"] as? String ?? "-"
        self.imdbrating = dict["imdbrating"] as? Double ?? -1
        print(imdbrating, "imdbratingimdbratingimdbrating")
        self.released = "\(dict["released"] as? Int ?? 0)"
        print(released, "releasedreleasedreleasedreleasedreleased")
        self.about = dict["synopsis"] as? String ?? "-"
        self.genre = dict["genre"] as? [String] ?? []
        print(genre, "genregenregenre")
        print(dict, "dictdictdictdictdictdictdict")
        self.dict = dict
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


}


struct MovieList {
    let movie:[Movie]
    let page:Int
}
