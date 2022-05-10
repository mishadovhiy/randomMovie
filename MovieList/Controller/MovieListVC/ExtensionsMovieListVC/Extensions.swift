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
        let bigger = ((self.page > (page ?? 0)) && (page != nil)) ? false : true
        if !bigger {
            self.tableData = []
        }

        let calcPage = page ?? (UserDefaults.standard.value(forKey: "page") as? Int ?? 1)
        let loadingPage = calcPage <= 0 || calcPage >= (self.load.maxPage + 10) ? 0 : calcPage
        
        print(self.page, "pagepagepagepagepage")
        if firstDispleyingPage == nil || self.page == 0 {
            firstDispleyingPage = self.page
        }
        DispatchQueue.init(label: "download", qos: .userInitiated).async {
            if self.tableData.count > 1000 {
                self.tableData.removeSubrange(0..<850)
            }
            self.load.getMovies(page: loadingPage) { movies, error, newPage in
                self.dataLoaded(movies: movies, error: error, newPage: newPage, loadingPage:loadingPage)
            }
        }
        
    }
    
    func dataLoaded(movies:[Movie], error:Bool, newPage:Int, loadingPage:Int) {
        print(error, " errorrrr")
        if error && (movies.count == 0) {
            print("Error and no loaded movies")
            DispatchQueue.main.async {
                self.message.show(type: .internetError)
            }
        }
        if ((newPage + 1) >= self.load.moviesCount) || (loadingPage > newPage) {
            self.stopDownloading = true
        }
        if self.tableData.count < 40 && movies.count < 40 {
            self.tableData.removeAll()
        }
        self.page = newPage
        self.loading = false
        for movie in movies {
            self.load.image(for: movie.imageURL) { data in
                movie.image = data
                self.tableData.append(movie)
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
        self.tableData = LocalDB.favoriteMovies
    }
    
    
    func getRandom() {
        switch screenType {
        case .favorite:
            let movies = LocalDB.favoriteMovies
            if let random = movies.randomElement() {
                self.selectedMovie = random
            } else {
                DispatchQueue.main.async {
                    self.shakeButton.isEnabled = true
                }
            }
            
        case .all:
            DispatchQueue.init(label: "download", qos: .userInitiated).async {
                self.load.getMovies(page: Int.random(in: 0..<self.load.maxPage)) { movies, error, newPage  in
                    if error && movies.count == 0 {
                        DispatchQueue.main.async {
                            self.message.show(type: .internetError)
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
            break
            
        }
        
    }
    
}
