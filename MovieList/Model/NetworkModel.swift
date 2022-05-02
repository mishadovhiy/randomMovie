//
//  NetworkModel.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

struct NetworkModel {
    
    private let urlString = "https://ott-details.p.rapidapi.com/"
    //"https://k2maan-moviehut.herokuapp.com/api/"
    private let apiKey = "77eb2877e4msh9e213a3cbcb9f58p1b5b3djsn82dd3c2c1d14"

    func loadMovies(limit:Int = 25, page:Int, completion:@escaping([Movie], Bool) -> ()) {
        let parameters = "sort=latest&page=\(page)"
        Load(task: .movies, parameters: parameters) { jsonResult, errorString in
            print(errorString ?? "no error string", "!errorString")
            print(jsonResult, " jsonResultjsonResult")
            
            guard let arrey = jsonResult["results"] as? NSArray else {
                completion([], true)
                return
            }
            var result:[Movie] = []
            for i in 0..<arrey.count {
                if let jsonElement = arrey[i] as? NSDictionary {
                    if let dict = jsonElement as? [String : Any] {
                        result.append(.init(dict: dict))
                    }
                }
            }

            let error = (errorString ?? "") != ""
            completion(result, error)
        }
    }
    
    
    
    
    
    private func Load(method:Method = .get, task:Task, parameters:String, completion:@escaping([String:Any], String?) -> ()) {
        
        let requestString = urlString + task.rawValue + parameters
        print(requestString, " requestStringrequestString")
        guard let url =  NSURL(string: requestString) else {
            completion([:], "Error creating url")
            return
        }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 100.0
        request.cachePolicy = .useProtocolCachePolicy
        if method != .post {
            let headers = [
                "X-RapidAPI-Host": "ott-details.p.rapidapi.com",
                "X-RapidAPI-Key": apiKey,
                "content-type": "application/json; charset=utf-8",
            ]
            request.allHTTPHeaderFields = headers
        }
        

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            

            if (error != nil) {
                completion([:], error?.localizedDescription)
                return
            } else {
                var jsonResult:[String:Any]?
                guard let dataa = data  else {
                    completion([:], "Error converting results")
                    return
                }
                
                do{
                    jsonResult = try JSONSerialization.jsonObject(with: dataa, options:.allowFragments) as? [String:Any] ?? [:]
                } catch let error as NSError {
                    completion([:], error.localizedDescription)
                    return
                }
                completion(jsonResult ?? [:], nil)

                
            }
        })

        dataTask.resume()
    }
}


extension NetworkModel {
    enum Method:String {
        case get = "GET"
        case post = "POST"
    }
    enum Task: String {
        case movies = "advancedsearch?"
    }
}

