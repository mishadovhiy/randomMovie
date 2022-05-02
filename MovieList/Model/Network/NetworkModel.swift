//
//  NetworkModel.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

struct NetworkModel {

    func loadMovies(limit:Int = 25, page:Int, completion:@escaping([Movie], Bool) -> ()) {
        let parameters = "sort=latest&page=\(page)"
        Load(task: .movies, parameters: parameters) { jsonResult, errorString in
            print(errorString ?? "no error string", "!errorString")
            print(jsonResult, " jsonResultjsonResult")
            let error = (errorString ?? "") != ""
            let result = Unparce.json(jsonResult)
            completion(result ?? [], error)
        }
    }
    
    //random num gen
//.1    //load mySQL
    //if mySQL != contains gen num
    //get from api page
    //if not error
    //save to mySQL
    //else if error
    //get other rundom page from loaded MySQL
    
//.1 else    //if error
    //get random local page
    
    
    //method to load data from mySQL table
    
    
    
    private func Load(method:Method = .get, task:Task, parameters:String, mySql:Bool = false, completion:@escaping([String:Any], String?) -> ()) {
        let url = mySql ? Keys.sqlURL : Keys.apiKey
        let requestString = url + task.rawValue + parameters
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
                "X-RapidAPI-Key": Keys.apiKey,
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

