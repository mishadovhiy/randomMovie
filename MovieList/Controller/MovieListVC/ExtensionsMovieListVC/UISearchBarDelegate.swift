//
//  UISearchBarDelegate.swift
//  MovieList
//
//  Created by Misha Dovhiy on 09.05.2022.
//

import UIKit

extension MovieListVC:UISearchBarDelegate {
    private func toWatchMovie(searchText:String?) {
        searchBar.endEditing(true)
        if let text = searchText,
           text != "", text.contains("tt") {
            let movie = Movie(dict: [:])
            movie.imdbid = text
            movie.name = text
            AppDelegate.shared?.banner.toggleFullScreenAdd(self, loaded: {
                AppDelegate.shared?.banner.interstitial = $0
                AppDelegate.shared?.banner.interstitial?.fullScreenContentDelegate = self
            }, closed: { presented in
                let vc = MovieVC.configure(movie: movie)
                self.present(vc, animated: true)
            })
        }
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        toWatchMovie(searchText: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        self.tableData = []
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(#function)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        toWatchMovie(searchText: searchBar.text)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print(searchText)
        DispatchQueue.init(label: "localDB", qos: .userInteractive).async {
            if let movies = self.load.getMovies(text: searchText) {
                self.tableData = searchText == "" ? [] : movies
            } else {
                DispatchQueue.main.async {
                    AppModel.Appearence.message.show(type: .internetError)
                }
            }
        }
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if keyboardHeight > 1.0 {
                DispatchQueue.main.async {
                    self.collectionView.contentInset.bottom = keyboardHeight
                }

            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            self.collectionView.contentInset.bottom = 0
           // self.collectionView.reloadData()
        }
    }
}
