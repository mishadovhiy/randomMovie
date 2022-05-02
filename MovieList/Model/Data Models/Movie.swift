//
//  Movie.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class Movie {
    let name:String
    let id:String
    let overview:String
    let releaseYear:Int
    let certificate:String
    let runtime:String
    let genre:String
    let imdbRating:Int
    let metaScore:String
    let director:String
    
    let dict:[String:Any]
    
    init(dict:[String:Any]) {
        self.name = dict["name"] as? String ?? "-"
        self.id = dict["_id"] as? String ?? "-"
        self.overview = dict["overview"] as? String ?? "-"
        self.releaseYear = dict["releaseYear"] as? Int ?? -1
        self.certificate = dict["certificate"] as? String ?? "-"
        self.runtime = dict["runtime"] as? String ?? "-"
        self.genre = dict["genre"] as? String ?? "-"
        self.imdbRating = dict["imdbRating"] as? Int ?? -1
        self.metaScore = dict["metaScore"] as? String ?? "-"
        self.director = dict["director"] as? String ?? "-"
        self.dict = dict
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
}
