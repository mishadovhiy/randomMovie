//
//  Filter.swift
//  MovieList
//
//  Created by Misha Dovhiy on 12.02.2023.
//

import UIKit

extension LocalDB {
    struct Filter {
        var dict:[String:Any]
        init(dict:[String:Any]) {
            self.dict = dict
        }
        
        

        
        var imdbRating:Rating {
            get {
                let imdb = dict["imdb"] as? [String:String] ?? [:]
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
                dict.updateValue(new, forKey: "imdb")
            }
        }

        
        
        var yearRating:Rating {
            get {
                let year = dict["year"] as? [String:String] ?? [:]
                return .init(from: Double.init(year["from"] ?? "1980") ?? 0.0,
                             to: Double.init(year["to"] ?? ("\(Date().components.year ?? 2020)")) ?? 0.0)
            }
            set {
                let new = [
                    "from":String.init(decimalsCount: 3, from: newValue.from),
                    "to":String.init(decimalsCount: 3, from: newValue.to)
                ]
                dict.updateValue(new, forKey: "year")
            }
        }
        
        var allGenres = ["Horror", "Comedy", "Drama", "Romance", "Sci-Fi", "Thriller", "Action", "Fantasy", "History", "Biography", "War", "Sport", "Adventure", "Crime", "Mystery", "Family", "Animation", "Music", "Musical", "Adult", "Western", "Documentary"]
        
        var ignoredGenres:[String:Bool] {
            get {
                return dict["ignoredGenres"] as? [String:Bool] ?? [:]
            }
            set {
                dict.updateValue(newValue, forKey: "ignoredGenres")
            }
        }
        
        var selectedGanres:[String] {
            
            return allGenres.filter({
                !(ignoredGenres[$0] ?? false)
            })
        }
        
        struct Rating {
            let from:Double
            let to:Double
        }
        
    }
}

