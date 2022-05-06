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
                return .init(from: Double.init(imdb["from"] ?? "4") ?? 0.0,
                             to: Double.init(imdb["to"] ?? "10") ?? 0.0)
            }
            set {
                let new = [
                    "from":String.init(decimalsCount: 3, from: newValue.from),
                    "to":String.init(decimalsCount: 3, from: newValue.to)
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
        
        
        struct Rating {
            let from:Double
            let to:Double
        }
        
    }
}
