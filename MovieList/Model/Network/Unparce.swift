//
//  Unparce.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

struct Unparce {
    
    
    static func movieList(_ jsonArrey:NSArray?, filter:Bool) -> [MovieList]? {
        guard let arrey = jsonArrey else {
            return nil
        }

        return arrey.data(dictKey: "results")?.compactMap({
            let dictt = jsonDataDict($0.0)
            let movies = Unparce.json(dictt ?? [:], filter: filter)
            let page = Double.init($0.1?["page"] as? String ?? "")
            return .init(movie: movies ?? [], page: Int(page ?? 0))
        })
    }
    
    //as [string:movie]
    //return (thecond method): for key valye
    static func json(_ jsonResult:[String:Any], filter:Bool = true) -> [Movie]? {
        guard let arrey = jsonResult["results"] as? NSArray else {
            return nil
        }
        var result:[Movie] = []
        for i in 0..<arrey.count {
            if let jsonElement = arrey[i] as? NSDictionary {
                if let dict = jsonElement as? [String : Any] {
                    let movie = Movie(dict: dict)
                    if movie.filterValidation(imgOnly: !filter)  {
                        result.append(movie)
                    }
                }
            }
        }
        return result
    }
    
    static func jsonDataDict(_ data:Data?) -> [String:Any]? {
        var jsonResult:[String:Any]?
        guard let dataa = data  else {
            return nil
        }
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: dataa, options:.allowFragments) as? [String:Any] ?? [:]
        } catch _ as NSError {
            return nil
        }
        return jsonResult
    }
    
    static func jsonDataArray(_ data:Data?) -> NSArray? {
        return data?.array
    }
    
    
    
    static func savedData(data:Data?) -> Bool {
        if let unwrappedData = data {
            let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
            if returnedData == "1" {
                return true
            } else {
                let r = returnedData?.trimmingCharacters(in: .whitespacesAndNewlines)
                return r == "1"
            }
        } else {
            return false
        }
    }
    
}

extension Unparce {
    struct OpenAIMovieResponse: Codable {
        var movies:[MovieList]
        struct MovieList:Codable {
            var description:String?
            var imageURL:String?
            var movieName:String?
            var releaseDate:String?
            var imdbid:String?
            var imdbrating:Double?
            
            
        }
    }
    
    struct MovieDetails:Codable {
        let movie_results:[Movie]
        struct Movie:Codable {
            var title:String?
            let release_date:String?
            let poster_path:String?
//            /// movie description
            let overview:String?
            let backdrop_path:String?
//            let popularity:String?
//            let genre_ids:[String]
        }
    }
}
