//
//  UISearchBarDelegate.swift
//  MovieList
//
//  Created by Misha Dovhiy on 09.05.2022.
//

import UIKit

extension MovieListVC:UISearchBarDelegate {
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        
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
        searchBar.endEditing(true)
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

