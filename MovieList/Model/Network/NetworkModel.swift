//
//  NetworkModel.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class NetworkModel {

    func getMovies(page:Int, completion:@escaping([Movie], Bool) -> ()) {
        loadSQLMovies { sqlMovies, error in
            if let movies = self.movieFor(page: page, list: sqlMovies) {
                completion(movies, error)
            } else {
                self.updateDBwithApi(page: page) { apiMovies, apiError in
                    let resultMovies:[Movie] = apiMovies.count == 0 ? (sqlMovies.randomElement()?.movie ?? []) : apiMovies
                    completion(resultMovies, apiError)
                }
            }
        }
    }
    

    
    func localImage(url:String) -> Data? {
        let ud = UserDefaults.standard.value(forKey: "movieImages") as? [String:Data?] ?? [:]
        if let result = ud[url] {
            return result
        } else {
            return nil
        }
    }
    
    func image(for url:String, completion:@escaping(Data?) -> ()) {
        if let localImage = localImage(url: url) {
            completion(localImage)
        } else {
            Load(method: .get, task: .img, parameters: "", urlString: url) { data, error in
                var ud = UserDefaults.standard.value(forKey: "movieImages") as? [String:Data?] ?? [:]
                ud.updateValue(data, forKey: url)
                UserDefaults.standard.setValue(ud, forKey: "movieImages")
                completion(data)
                
            }
        }
        
        
    }
    
    
    
    
    private func updateDBwithApi(page:Int, completion:@escaping([Movie], Bool) -> ()) {
        let parameters = "sort=latest&page=\(page)"
        Load(task: .movies, parameters: parameters) { data, error in
            guard let dataa = data else {
                completion([],true)
                return
            }
            guard let dictionary = Unparce.jsonDataDict(dataa) else {
                completion([],true)
                return
            }
            let movies = Unparce.json(dictionary)
            let saveJson = dataa.base64EncodedString()
            let saveParameters = "page=\(page)&results=\(saveJson)"

            self.Load(method: .post, task: .saveMovie, parameters: saveParameters) { saveData, errorSaveString in
                let sended = Unparce.savedData(data: saveData)
                print(sended, "sendedsendedsendedsendedsended")
                completion(movies ?? [], false)
                
            }
        }
    }
    
    
    
    private func movieFor(page:Int, list:[MovieList]) -> [Movie]? {
        for item in list {
            if item.page == page {
                return item.movie
            }
        }
        return nil
    }
    
    var mySqlMovieList:[MovieList]?
    private func loadSQLMovies(completion:@escaping([MovieList], Bool) -> ()) {
        if let movieList = mySqlMovieList {
            completion(movieList, false)
        } else {
            Load(task: .sqlMovies, parameters: "") { data, errorString in
                print(errorString ?? "no error", " errorStringerrorStringerrorString")
                let error = (errorString ?? "") != ""
                let jsonResult = Unparce.jsonDataArray(data)
                let result = Unparce.json(jsonResult)
                self.mySqlMovieList = result
                completion(result ?? [], error)
            }
        }
        
    }

    
    private func Load(method:Method = .get, task:Task, parameters:String, urlString:String? = nil, completion:@escaping(Data?, String?) -> ()) {//movies
        let mySQL = task.rawValue.contains(".php")
        let url = mySQL ? Keys.sqlURL : Keys.apiURL
        let urlParam = task == .saveMovie ? "" : parameters
        let requestString = urlString ?? (url + task.rawValue + urlParam)
        print(requestString, " requestStringrequestString")
        guard let url =  NSURL(string: requestString) else {
            completion(nil, "Error creating url")
            return
        }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 100.0
        request.cachePolicy = .useProtocolCachePolicy
        if method != .post {
            let headers = mySQL ? [
                "content-type": "application/json; charset=utf-8",
            ] : [
                "X-RapidAPI-Host": "ott-details.p.rapidapi.com",
                "X-RapidAPI-Key": Keys.apiKey,
                "content-type": "application/json; charset=utf-8",
            ]
            request.allHTTPHeaderFields = headers
        }
        var dataUpload:Data? {
            if method != .post {
                return nil
            }
            var dataToSend = ""//"secretWord=" + Keys.secretKey
            dataToSend = dataToSend + parameters
            return dataToSend.data(using: .utf8)
        }

        performTask(method: method, request: request as URLRequest, data: dataUpload) { resultData, response, error in
            if (error != nil) {
                completion(nil, error?.localizedDescription)
                return
            } else {
                completion(resultData, nil)
            }
        }
    }
    
    
    private func performTask(method:Method, request:URLRequest, data:Data?, completion:@escaping (Data?, URLResponse?, Error?) -> Void) {
        if method == .post {
            let dataTask = URLSession.shared.uploadTask(with: request, from: data, completionHandler: completion)
            dataTask.resume()
        } else {
            let dataTask = URLSession.shared.dataTask(with: request, completionHandler: completion)
            dataTask.resume()
        }
    }

}


extension NetworkModel {
    enum Method:String {
        case get = "GET"
        case post = "POST"
    }
    enum Task: String {
        case movies = "advancedsearch?"
        case sqlMovies = "LoadMovies.php"
        case saveMovie = "NewMovie.php?"
        case img = ""
    }
}

