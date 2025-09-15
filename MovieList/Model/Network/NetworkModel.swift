//
//  NetworkModel.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

struct NetworkModel {

    var maxPage = 490
    
    func loadAppSettings(completion:@escaping()->()) {
        let sesson = URLSession.shared.dataTask(with: .init(string: "https:/mishadovhiy.com/apps/other-apps-db/moviesDB/randomMovie.json")!) { data, response, error in
            let dict = data?.jsonDictionary
            print(dict, " tgerfsdgfd")
            if let token = dict?["openAIToken"] as? String {
                LocalDB.db.tempOpenAI = token
            } else {
                print("errorloadingtoken")
            }
            completion()
        }
        sesson.resume()
    }
    
    func extractSubstring(from text: String) -> String? {
        let pattern = "listStart\\s*(.*?)\\s*listEnd"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: text.count)
        
        if let match = regex.firstMatch(in: text, options: [], range: range) {
            let matchRange = match.range(at: 1)
            let substring = (text as NSString).substring(with: matchRange)
            return substring
        }
        
        return nil
    }
    
    
    func movieByID(completion:@escaping()->()) {
        
    }
    
    /**
     curl --request GET \
          --url 'https://api.themoviedb.org/3/find/tt0113680?external_source=imdb_id' \
          --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NDZjN2YwZTQ4ZGNkYmFhNGRmZDQxZDU2MTY0YzcxZSIsIm5iZiI6MTY1MTU0MDc4NS4xMTgsInN1YiI6IjYyNzA4MzMxMDM3MjY0MDA1MWZhZDFjYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fRhl1zoTX2b-SC4k31ALnL6yocF2xjTZ4gejtzptv9U' \
          --header 'accept: application/json'
     */
#warning("respond tv_results or movie_results")
    /**
     "tv_results": <__NSSingleObjectArrayI 0x3006170a0>(
     {
         adult = 0;
         "backdrop_path" = "/a4doyPOabvQor0RGkWdhVENAR3G.jpg";
         "first_air_date" = "2011-10-05";
         "genre_ids" =     (
             18,
             9648,
             10765
         );
         id = 1413;
         "media_type" = tv;
         name = "American Horror Story";
         "origin_country" =     (
             US
         );
         "original_language" = en;
         "original_name" = "American Horror Story";
         overview = "An anthology horror drama series centering on different characters and locations, including a house with a murderous past, an asylum, a witch coven, a freak show, a hotel, a farmhouse in Roanoke, a cult, the apocalypse and a summer camp.";
         popularity = "126.952";
         "poster_path" = "/5LLG9bjq0i7V5N4UfRhnab8zHK4.jpg";
         "vote_average" = "8.116";
         "vote_count" = 5697;
     }
     )
     */

    /**
     "movie_results": <__NSSingleObjectArrayI 0x30061d210>(
     {
         adult = 0;
         "backdrop_path" = "/8UOdqhVP28OcnzNL6DnQf0GDLvR.jpg";
         "genre_ids" =     (
             18
         );
         id = 881;
         "media_type" = movie;
         "original_language" = en;
         "original_title" = "A Few Good Men";
         overview = "When cocky military lawyer Lt. Daniel Kaffee and his co-counsel, Lt. Cmdr. JoAnne Galloway, are assigned to a murder case, they uncover a hazing ritual that could implicate high-ranking officials such as shady Col. Nathan Jessep.";
         popularity = "19.879";
         "poster_path" = "/rLOk4z9zL1tTukIYV56P94aZXKk.jpg";
         "release_date" = "1992-12-11";
         title = "A Few Good Men";
         video = 0;
         "vote_average" = "7.547";
         "vote_count" = 3709;
     }
     )
     */
    ///dict:
    /// movie_results
    /// movie_results
    //randomMovie - unparce codable movie_results/tv_result
    func movieDetails(id:String,
                              completion:@escaping(_ movie:Movie?)->()) {
        var request = URLRequest(url: .init(string: "https://api.themoviedb.org/3/find/\(id)?external_source=imdb_id")!)
        request.setValue("""
Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NDZjN2YwZTQ4ZGNkYmFhNGRmZDQxZDU2MTY0YzcxZSIsIm5iZiI6MTY1MTU0MDc4NS4xMTgsInN1YiI6IjYyNzA4MzMxMDM3MjY0MDA1MWZhZDFjYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fRhl1zoTX2b-SC4k31ALnL6yocF2xjTZ4gejtzptv9U
""", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            let jsonDictionary = try? JSONSerialization.jsonObject(with: data ?? .init(), options: []) as? [String: Any]
#warning("unparcemoviedetailshere")
            print(jsonDictionary, " jsondictionarymoviedetails ")
            print(jsonDictionary?["movie_results"] as? [[String:Any]])
            let responseJson = try? JSONDecoder().decode(Unparce.MovieDetails.self, from: data ?? .init())
            print("fwedawfed ", responseJson, " ghbjnkm ")
            if let movie = responseJson, (responseJson?.movie?.count ?? 0) >= 1 {
                print("gdfsdfb ", movie)
                let movieResult = Movie.configure(movie)
                movieResult.imdbid = id
                movieResult.imageURL = "https://image.tmdb.org/t/p/w500" + movieResult.imageURL
                print(movieResult.imageURL, " efrwdwfr ")
                completion(movieResult)
            } else {
                completion(nil)
            }
            
        }
        session.resume()
    }
    
    func openAIMovies(completion:@escaping([Movie])->()) {
            var request = URLRequest(url: .init(string: "https://api.openai.com/v1/chat/completions")!)
        let description = LocalDB.db.text != "" ? "with description " + LocalDB.db.text : ""
        let prompt = "Generate 10 random movies imdbids (comma separeted) as solid string in the genre of \(LocalDB.db.filter.selectedGanres.joined(separator: ", ")) from \(LocalDB.db.filter.yearRating.from) to \(LocalDB.db.filter.yearRating.to) \(description). add 'listStart' before list and 'listEnd' at the end, wrapp list in the structure: \(RecommendationKeys.allCases.prompt)"//urls where i can stream movie
        print(prompt, " rtgefwds")
            let jsonBody: [String: Any] = [
                    "model": "gpt-3.5-turbo",
                    "messages": [
                        ["role": "system", "content": "You are a helpful assistant."],
                        ["role": "user", "content": prompt]
                    ],
                    "max_tokens": 4096
                ]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
                    print("Error serializing JSON")
                    return
                }
                let token = LocalDB.db.tempOpenAI
            request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.httpBody = httpBody
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data,
                    let responseJson = try? JSONDecoder().decode(OpenAIMessageResponse.self, from: data) {
                    var message = responseJson.choices.first?.message?.content ?? ""
                    print(responseJson.choices.count, " etgrfsd")
                    print(message, " grerfedgvefs ")
                    let cleanedJsonString = self.extractSubstring(from: message) ?? ""
                    print("fsdas ", cleanedJsonString, " tregfesd")
                    let array =  message.arrayOfPattern()
                  //  if cleanedJsonString.contains("tt"), array.count >= 1 {
                        var results:[Movie] = []
                        print("loadingmoviedetailses ", array.count)
                    array.forEach { str in
                            var dict:[RecommendationKeys:String] = [:]
                            RecommendationKeys.allCases.forEach { key in
                                let text = String(str).extractSubstring(key: key.rawValue)
                                dict.updateValue(text ?? "", forKey: key)
                            }

                            self.movieDetails(id: String(dict[.imdbID] ?? "")) { movie in
                                if let movie {
                                    results.append(movie)
                                    print("appendfaddsasd ", array.count)
                                } else {
                                    print("errorloadingmoviedetail ", str)
                                    
                                    let movie = Movie.configure(.init(description: dict[.description], imageURL: "", movieName: dict[.name], releaseDate: "", imdbid: dict[.imdbID], imdbrating: nil))
                                    results.append(movie)
                                }
                                
                                if str == array.last {
                                    completion(results)
                                }
                            }
                        }
                //    } else {
                     //   completion([])
                   // }
                    
                } else {
                    completion([])
                    print(data?.jsonDictionary, "error unparcing response")
                }
            }
            session.resume()
        }

    
    func openAIMoviesOld(completion:@escaping([Movie])->()) {
            var request = URLRequest(url: .init(string: "https://api.openai.com/v1/chat/completions")!)
            let prompt = "Generate 10 random movies in the genre of horror, comedy, or thriller from 1990 to 2000. Please provide the response in JSON format, with each entry containing the fields: 'movieName', 'description', and 'imageURL', 'imdbid', 'imdbrating' as double, 'releaseDate' as string date"//urls where i can stream movie
            let jsonBody: [String: Any] = [
                    "model": "gpt-3.5-turbo",
                    "messages": [
                        ["role": "system", "content": "You are a helpful assistant."],
                        ["role": "user", "content": prompt]
                    ],
                    "max_tokens": 4096
                ]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
                    print("Error serializing JSON")
                    return
                }
                let token = LocalDB.db.tempOpenAI
            request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.httpBody = httpBody
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data,
                    let responseJson = try? JSONDecoder().decode(OpenAIMessageResponse.self, from: data) {
                    let message = responseJson.choices.first?.message?.content ?? ""
                    print(responseJson.choices.count, " etgrfsd")
                    print(message, " grerfedgvefs ")
                    let cleanedJsonString = message
                                            .replacingOccurrences(of: "```json\n", with: "")
                                            .replacingOccurrences(of: "\n", with: "")
                    
                                            .replacingOccurrences(of: "endingWoerdTestingsddsf", with: "")
                                            .replacingOccurrences(of: "```", with: "").replacingOccurrences(of: "json", with: "")
                                            .components(separatedBy: "``` \nendingWoerdTestingsddsf").first ?? message
                                    print(cleanedJsonString, " tregfesd")
                    let jsonData = cleanedJsonString.data(using: .utf8)
                    let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData ?? .init(), options: []) as? [String: Any]
                    print(jsonDictionary, " grefdsas")
                    if let jsonData = cleanedJsonString.data(using: .utf8),
                                       let jsonDictionary = try? JSONDecoder().decode(Unparce.OpenAIMovieResponse.self, from: jsonData)
                    {
                                            print(jsonDictionary, " rgef")
                        completion(jsonDictionary.movies.compactMap({
                            .configure($0)
                        }))
                                        } else {

                                            print("errorcreatingdatafromjson ", jsonDictionary)
                                            completion([])
                                        }
                } else {
                    completion([])
                    print(data?.jsonDictionary, "error unparcing response")
                }
            }
            session.resume()
        }
    
    func movieStream(imdbid:String, completion:@escaping()->()) {
        Load(task: .moviewSteam, parameters: imdbid) { data, string in
            print("sfeawds dataaa: ", data)
            print("str: ", string)
        }
    }
    
    func getMovies(page:Int, completion:@escaping([Movie], Bool, Int, Int) -> ()) {
        loadSQLMovies { sqlMovies, error in
            let data = self.movieFor(page: page, list: sqlMovies)
            if let moviesData = data.movies {
                completion(moviesData, error, data.lastPage, data.listCount)
            } else {
                self.updateDBwithApi(page: page) { apiMovies, apiError in
                    let resultMovies:[Movie] = apiMovies.count == 0 ? (sqlMovies.randomElement()?.movie ?? []) : apiMovies
                    completion(resultMovies, error, data.lastPage, resultMovies.count)
                }
            }
        }
        
    }
    
    func getMovies(text:String) -> [Movie]? {
        let searchingText = text.uppercased()
        if let movieList = AppModel.mySqlMovieList {
            let result = sqlLoaded(data: movieList, filter: false)
            var resultMovies:Set<Movie> = []
            for movies in result {
                for movie in movies.movie {
                    if
                        movie.name.uppercased().contains(searchingText.uppercased()) ||
                        searchingText.uppercased().contains(movie.imdbid.uppercased()) ||
                        searchingText.uppercased().contains(movie.released.uppercased()) ||
                        movie.genreString.uppercased().contains( searchingText.uppercased())
                    {
                        resultMovies.insert(movie)
                    }
                }
            }
            return Array(resultMovies)
        } else {
            return nil
        }
        
    }

    
    func localImage(url:String, fromHolder:Bool = true) -> Data? {
       /* let ud = !fromHolder ? LocalDB.db.movieImages : (LocalDB.dbHolder?.movieImages ?? [:])
        if let result = ud[url] {
            return result["img"] as? Data
        } else {
            return nil
        }*/
        return nil
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
                if let data = data {
                  /*  var ud = LocalDB.db.movieImages
                    let new:[String:Any] = self.newImageData(data)
                    ud.updateValue(new, forKey: url)*/
                  //  LocalDB.db.movieImages = self.newImageData(data)
                }
                
                completion(data)
                
            }
        }
        
        
    }
    
    func newImageData(_ data:Data) -> [String:Any] {
        return [
            "img":data,
            "date":Date()
        ]
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
            //updates my mysql
            self.Load(method: .post, task: .saveMovie, parameters: saveParameters) { saveData, errorSaveString in
                let sended = Unparce.savedData(data: saveData)
                print(sended, "sendedsendedsendedsendedsended")
                completion(movies ?? [], false)
                
            }
        }
    }
    
    
    private func movieFor(page:Int, list:[MovieList]) -> (movies: [Movie]?, lastPage:Int, listCount:Int) {
        var result:[Movie] = []
        let sorted = list.sorted { $0.page < $1.page }

        for i in 0..<sorted.count {

            if sorted[i].page == page {
                result = result + (sorted[i].movie)
                if result.count >= 50 {
                    return (result, sorted[i].page, list.count)
                }
            } else {
                if sorted[i].page > page {
                    result = result + (sorted[i].movie)
                    if result.count >= 50 {
                        return (result, sorted[i].page, list.count)
                    }
                }
            }
            
        }
        
        return (result, 0, list.count)
    }
    
    
    func loadSQLMovies(completion:@escaping(_ loadedData:[MovieList], _ error:Bool) -> ()) {
        if let movieList = AppModel.mySqlMovieList {
            let result = sqlLoaded(data: movieList)
            completion(result, false)
        } else {
            Load(task: .sqlMovies, parameters: "") { data, errorString in
                let error = (errorString ?? "") != ""
                let result = self.sqlLoaded(data: error ? LocalDB.db.mySqlMovieListUD : data)
                completion(result, error)
            }
        }
    }
        
    private func sqlLoaded(data:Data?, filter:Bool = true) -> [MovieList] {
        if AppModel.mySqlMovieList == nil {
            AppModel.mySqlMovieList = data
            LocalDB.db.mySqlMovieListUD = data
        }
        let jsonResult = Unparce.jsonDataArray(data)
        return Unparce.movieList(jsonResult, filter: filter) ?? []
    }

    

    
    
    private func Load(optUrl:String? = nil, method:Method = .get, task:Task, parameters:String, urlString:String? = nil, completion:@escaping(Data?, String?) -> ()) {//movies
        let mySQL = task.rawValue.contains(".php")
        let url = task.url//mySQL ? Keys.sqlURL : Keys.apiURL
        let urlParam:String
        switch task {
        case .saveMovie: urlParam = ""
        default: urlParam = parameters
        }
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
                "X-RapidAPI-Key": task.key,
                "content-type": "application/json; charset=utf-8",
            ]
            request.allHTTPHeaderFields = headers
        }
        print(parameters, " parametersparametersparametersparameters")
        var dataUpload:Data? {
            if method != .post {
                return nil
            }
            return parameters.data(using: .utf8)
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
        if Thread.isMainThread {
            print("gerfwregtbrgfvd!!!")
        }
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
        case moviewSteam = "/"
        
        var url:String {
            switch self {
            case .movies:
                return Keys.apiURL
            case .sqlMovies, .saveMovie:
                return Keys.sqlURL
            case .img:
                return ""
            case .moviewSteam: return Keys.movieStreamURL
            }
        }
        
        var key:String {
            switch self {
            case .movies: return Keys.apiKey
            default: return ""
            }
        }
    }
}

extension Data {
    var jsonDictionary: [String:Any]? {
        let json = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        return json
    }
}

extension NetworkModel {
    struct OpenAIMessageResponse:Codable {
        let choices:[Choices]
        struct Choices:Codable {
            let message:Message?
            struct Message:Codable {
                let content:String?
            }
        }
    }
}
extension String {
    func arrayOfPattern() -> [Self] {
        let pattern = "<listItem>(.*?)</listItem>"

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            
            // Map the matches to the text between the tags
            let extractedTexts = matches.map { match -> String in
                let range = match.range(at: 1) // Range of the text inside <listItem>...</listItem>
                let substring = (self as NSString).substring(with: range)
                return substring
            }
            
            // Output the array of extracted texts
            print(extractedTexts)
            return extractedTexts
        } catch {
            print("Invalid regular expression")
            return []
        }
    }
    func extractSubstring(key:String) -> String? {
        let pattern = "<\(key)>(.*?)</\(key)>"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
            
                return nil
            }
            
            let range = NSRange(self.startIndex..<self.endIndex, in: self)
        if let match = regex.firstMatch(in: self, options: [], range: range) {
                
                let rangeStart = match.range(at: 1)
                if let swiftRange = Range(rangeStart, in: self) {
                    return String(self[swiftRange])
                }
            }
        
        return nil
    }

}
/// for ai request
enum RecommendationKeys: String, CaseIterable {
    
    case imdbID
    case name
    case description
    case ganre
    
    var description: String {
        switch self {
        case .description:
            "Movie description in 3 senteces"
        default: rawValue
        }
    }
}

extension [RecommendationKeys] {
    var prompt: String {
        let list = self.compactMap({
            "<" + $0.rawValue + ">" + $0.description + "</" + $0.rawValue + ">"
        }).joined(separator: ", ")
        return "<listItem>\(list)</listItem>"
    }
}

