//
//  NetworkModel.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class NetworkModel {

    var maxPage = 490
    
    func getMovies(page:Int, completion:@escaping([Movie], Bool, Int) -> ()) {
        loadSQLMovies { sqlMovies, error in
            let data = self.movieFor(page: page, list: sqlMovies)
            print(data.lastPage, "datadatadatadatadatadatadatadata")
            if let moviesData = data.movies {
                completion(moviesData, error, data.lastPage)
            } else {
                self.updateDBwithApi(page: page) { apiMovies, apiError in
                    let resultMovies:[Movie] = apiMovies.count == 0 ? (sqlMovies.randomElement()?.movie ?? []) : apiMovies
                    completion(resultMovies, apiError, data.lastPage)
                }
            }
        }
        
    }
    

    
    func localImage(url:String) -> Data? {
        let ud = LocalDB.movieImages
        if let result = ud[url] {
            return result
        } else {
            return nil
        }
    }
    
    func image(for url:String, completion:@escaping(Data?) -> ()) {
        if url == "" {
            completion(nil)
            return
        }
        if let localImage = localImage(url: url) {
            completion(localImage)
        } else {
            Load(method: .get, task: .img, parameters: "", urlString: url) { data, error in
                var ud = LocalDB.movieImages
                ud.updateValue(data, forKey: url)
                LocalDB.movieImages = ud
                completion(data)
                
            }
        }
        
        
    }
    
    
    
    
    private func updateDBwithApi(page:Int, completion:@escaping([Movie], Bool) -> ()) {
        guard let parameters = (Keys.apiDefaultParameters + "\(page)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion([],true)
            return
        }
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
            
            var hasImage = "false"
            if let movies = movies {
                for movie in movies {
                    if movie.imageURL != "" {
                        hasImage = "true"
                    }
                }
            }
            let saveParameters = "page=\(page)&results=\(saveJson)&hasImage=\(hasImage)"
            self.Load(method: .post, task: .saveMovie, parameters: saveParameters) { saveData, errorSaveString in
                let sended = Unparce.savedData(data: saveData)
                print(sended, "sendedsendedsendedsendedsended")
                completion(movies ?? [], false)
                
            }
        }
    }
    
    var moviesCount = 0
    
    private func movieFor(page:Int, list:[MovieList]) -> (movies: [Movie]?, lastPage:Int) {
        var result:[Movie] = []
        moviesCount = list.count
        let sorted = list.sorted { $0.page < $1.page }
        //.sorted { Double($0.value) ?? 0.0 < Double($1.value) ?? 0.0 }
        for i in 0..<sorted.count {
            print("pageee ", sorted[i].page, "movies count: ", sorted[i].movie.count)
            if sorted[i].page == page {
                result = result + (sorted[i].movie)
                if result.count >= 50 {
                    print("pageee return ", sorted[i].page)
                    return (result, sorted[i].page)
                }
            } else {
                if sorted[i].page > page {
                    result = result + (sorted[i].movie)
                    if result.count >= 50 {
                        print("pageee return ", sorted[i].page)
                        return (result, sorted[i].page)
                    }
                }
            }
            
        }
        print("isResulttt")
        return (result, 0)
    }
    
    var mySqlMovieList:Data?
    private func loadSQLMovies(completion:@escaping([MovieList], Bool) -> ()) {
        if let movieList = mySqlMovieList {
            let result = sqlLoaded(data: movieList)
            completion(result, false)
        } else {
            Load(task: .sqlMovies, parameters: "") { data, errorString in
                print(errorString ?? "no error", " errorStringerrorStringerrorString")
                let error = (errorString ?? "") != ""
                let result = self.sqlLoaded(data: data)
                completion(result, error)
            }
        }
    }
        
    private func sqlLoaded(data:Data?) -> [MovieList] {
        if mySqlMovieList == nil {
            mySqlMovieList = data
        }
        let jsonResult = Unparce.jsonDataArray(data)
        return Unparce.json(jsonResult) ?? []
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
            var dataToSend = ""
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
