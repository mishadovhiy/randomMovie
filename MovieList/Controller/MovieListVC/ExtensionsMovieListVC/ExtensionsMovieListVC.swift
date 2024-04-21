//
//  Extensions.swift
//  MovieList
//
//  Created by Misha Dovhiy on 09.05.2022.
//

import UIKit

extension MovieListVC {
    func download(_ page:Int? = nil) {
        if loading {
            return
        }
        loading = true
        
        DispatchQueue.init(label: "download", qos: .userInitiated).async {
            let dbPage = LocalDB.db.page
            let bigger = ((dbPage > (page ?? 0)) && (page != nil)) ? false : true
            if !bigger {
                self.tableData = []
            }

            let calcPage = page ?? dbPage
            let loadingPage = calcPage <= 0 || calcPage >= (self.load.maxPage + 10) ? 0 : calcPage
            
            print(dbPage, "pagepagepagepagepage")
            if self.firstDispleyingPage == nil || dbPage == 0 {
                self.firstDispleyingPage = dbPage
            }
            if self.tableData.count > 1000 {
                self.tableData.removeSubrange(0..<850)
            }
            self.load.getMovies(page: loadingPage) { movies, error, newPage,listCount  in
                self.dataLoaded(movies: movies, folders:[], error: error, newPage: newPage, loadingPage:loadingPage, listCount: listCount)
            }
        }
        
    }
    
    func dataLoaded(movies:[Movie], folders:[LocalDB.DB.Folder], error:Bool, newPage:Int, loadingPage:Int, listCount:Int) {
        print(error, " errorrrr")
        if error && (movies.count == 0) {
            print("Error and no loaded movies")
            DispatchQueue.main.async {
                AppModel.Appearence.message.show(type: .internetError)
            }
        }
        if ((newPage + 1) >= listCount) || (loadingPage > newPage) {
            self.stopDownloading = true
        }
        if self.tableData.count < 40 && movies.count < 40 {
            self.tableData.removeAll()
        }
        if screenType == .favorite {
            self.tableData.removeAll()
        }
        LocalDB.db.page = newPage
        self.loading = false
     //   var newImages:[[String:Any]] = []
     /*   var all = LocalDB.db.movieImages

        for movie in movies {
            self.load.image(for: movie.imageURL) { data in
                movie.image = data
                self.tableData.append(movie)
              //  newImages.append()
                if let data = data {
                    all.updateValue(NetworkModel().newImageData(data), forKey: movie.imageURL)

                }
            }
        }

        LocalDB.db.movieImages = all*/
        self.folders = folders
        movies.sorted(by: {$0.imdbrating > $1.imdbrating}).forEach { movie in
            if !tableData.contains(where: {movie.imdbid == $0.imdbid}) {
                self.load.image(for: movie.imageURL) { data in
                    movie.image = data
                    self.tableData.append(movie)
                }
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.refresh?.isRefreshing ?? true {
                self.refresh?.endRefreshing()
            }
        }
    }
    
    func loadFavorites() {
        let db = LocalDB.db
        var newTableData:[Movie] = []
        if selectedFolder == nil {
            newTableData = db.favoriteMovies.filter({$0.folderID == nil})
            db.folders.forEach({
                newTableData.append(.init(folder: $0))
            })
        } else {
            print(selectedFolder?.id, " tgerfwdas")
            db.favoriteMovies.forEach {
                print($0.dict, " yhgtfredsw")
            }
            newTableData = db.favoriteMovies.filter({$0.folderID == selectedFolder?.id})
            print(newTableData, " gerfwedsx")
        }
        self.dataLoaded(movies: newTableData, folders: LocalDB.db.folders, error: false, newPage: 1, loadingPage:1, listCount: 1)
       // self.tableData = newTableData
    }
    
    
    func getRandom() {
        switch screenType {
        case .favorite:
            DispatchQueue.init(label: "download", qos: .userInitiated).async {
                let movies = LocalDB.db.favoriteMovies
                if let random = movies.randomElement() {
                    DispatchQueue.main.async {
                        self.selectedMovie = random
                    }
                } else {
                    DispatchQueue.main.async {
                        self.shakeButton.isEnabled = true
                        (self.shakeButton as! LoadingButton).touch(false)
                    }
                }
            }
        case .all:
            DispatchQueue.init(label: "download", qos: .userInitiated).async {
                self.load.getMovies(page: Int.random(in: 0..<self.load.maxPage)) { movies, error, newPage,_   in
                    if error && movies.count == 0 {
                        DispatchQueue.main.async {
                            AppModel.Appearence.message.show(type: .internetError)
                        }
                    }
                    if let random = movies.randomElement() {
                        self.selectedMovie = random
                    } else {
                        self.getRandom()
                    }
                }
            }
        default:
            selectedMovie = tableData.randomElement()
            self.shakeButton.isEnabled = true
            (self.shakeButton as! LoadingButton).touch(false)
        }
        
    }
    
}
