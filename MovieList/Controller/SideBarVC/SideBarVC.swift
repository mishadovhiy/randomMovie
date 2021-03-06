//
//  SideBarVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 20.05.2022.
//

import UIKit

class SideBarVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    static var shared:SideBarVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideBarVC.shared = self
        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    

    var tableData:[TableData] = []
    let sectionsBeforeData = 1
    
    func getData(){

        let imdbData:RangeSliderView = .init(min: 4, max: 10,
                                             selectedMin: LocalDB.Filter.imdbRating.from,
                                             selectedMax: LocalDB.Filter.imdbRating.to,
                                             digitsCount: 1)
        let imdbCell:SliderCellData = .init(range: imdbData, newPosition: newImdbRange)
        

        let yearData:RangeSliderView = .init(min: 1980, max: 2022,
                                             selectedMin: LocalDB.Filter.yearRating.from,
                                             selectedMax: LocalDB.Filter.yearRating.to,
                                             digitsCount: 0)
        let yearCell:SliderCellData = .init(range: yearData, newPosition: newYearRange)
        
        let genres = LocalDB.Filter.allGenres
        var ganrs : [CollectionCellData.ColldetionData] = []
        let ignoredList = LocalDB.Filter.ignoredGenres
        for ganr in genres {
            let ignored = ignoredList[ganr] ?? false
            ganrs.append(.init(name: ganr, ignored: ignored))
        }
        let genresCell:CollectionCellData = .init(collectionData: ganrs, selected: genreSelected(_:))
        
        tableData = [
            .init(cells: imdbCell, title: "imdb rating"),
            .init(cells: yearCell, title: "year range"),
            .init(cells: genresCell, title: "genre")
        ]
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

    @IBAction func favoritesPressed(_ sender: Any) {
        toListVC(type: .favorite)
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        toListVC(type: .search)
    }
    

}


extension SideBarVC {
    func newImdbRange(_ newValue:(Double, Double)) {
        let new:LocalDB.Filter.Rating = .init(from: newValue.0, to: newValue.1)
        let old = LocalDB.Filter.imdbRating
        if newRating(new: new, old: old, decimalsCount: 1) {
            LocalDB.Filter.imdbRating = new
        }
    }
    
    func newYearRange(_ newValue:(Double, Double)) {
        let new:LocalDB.Filter.Rating = .init(from: newValue.0, to: newValue.1)
        let old = LocalDB.Filter.yearRating
        if newRating(new: new, old: old, decimalsCount: 0) {
            LocalDB.Filter.yearRating = new
        }
    }
    
    func genreSelected(_ at:Int) {
        print(#function, ": ", at)
        let genres = LocalDB.Filter.allGenres
        if #available(iOS 13.0, *) {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } else {
            // Fallback on earlier versions
        }
        let igoneredList = LocalDB.Filter.ignoredGenres
        let ignored = igoneredList[genres[at]] ?? false
        LocalDB.Filter.ignoredGenres.updateValue(!ignored, forKey: genres[at])
        getData()
    }
    
    
    private func newRating(new:LocalDB.Filter.Rating, old:LocalDB.Filter.Rating, decimalsCount:Int) -> Bool {
        let c = decimalsCount
        if (convert(new.to, count: c) != convert(old.to, count: c)) ||
            (convert(new.from, count: c) != convert(old.from, count: c)) {
            return true
        } else {
            return false
        }
    }
    
    private func convert(_ value: Double, count:Int = 1) -> String {
        return String.init(decimalsCount: count, from: value)
    }
}
