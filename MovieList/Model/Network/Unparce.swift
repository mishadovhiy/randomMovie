//
//  Unparce.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class Unparce {
    
    
    static func movieList(_ jsonArrey:NSArray?) -> [MovieList]? {
        guard let arrey = jsonArrey else {
            return nil
        }
        var result:[MovieList] = []
        for i in 0..<arrey.count {
            if let jsonElement = arrey[i] as? NSDictionary {
                if let dict = jsonElement as? [String : Any] {
                    guard let resultString = dict["results"] as? String else {
                        break
                    }
                    let data = Data(base64Encoded: resultString, options: .ignoreUnknownCharacters)
                    let dictt = jsonDataDict(data)
                    let movies = Unparce.json(dictt ?? [:])
                    let page = Double.init(dict["page"] as? String ?? "")
                    let list:MovieList = .init(movie: movies ?? [], page: Int(page ?? 0))
                    result.append(list)
                }
            }
        }
        return result
    }
    
    static func json(_ jsonResult:[String:Any]) -> [Movie]? {
        guard let arrey = jsonResult["results"] as? NSArray else {
            return nil
        }
        var result:[Movie] = []
        for i in 0..<arrey.count {
            if let jsonElement = arrey[i] as? NSDictionary {
                if let dict = jsonElement as? [String : Any] {
                    let movie = Movie(dict: dict)
                    let release = dict[""]
                    if movie.filterValidation() {
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
        var jsonResult:NSArray?
        guard let dataa = data  else {
            return nil
        }
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: dataa, options:.allowFragments) as? NSArray ?? []
        } catch _ as NSError {
            return nil
        }
        return jsonResult
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
