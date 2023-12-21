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
        DispatchQueue(label: "db", qos: .userInitiated).async {
            self.getData()
        }
    }
    

    var tableData:[TableData] = []
    let sectionsBeforeData = 1
    
    func getData(){

        let imdbData:RangeSliderView = .init(min: 4, max: 10,
                                             selectedMin: LocalDB.db.filter.imdbRating.from,
                                             selectedMax: LocalDB.db.filter.imdbRating.to,
                                             digitsCount: 1)
        let imdbCell:SliderCellData = .init(range: imdbData, newPosition: newImdbRange)
        

        let yearData:RangeSliderView = .init(min: 1980, max: 2022,
                                             selectedMin: LocalDB.db.filter.yearRating.from,
                                             selectedMax: LocalDB.db.filter.yearRating.to,
                                             digitsCount: 0)
        let yearCell:SliderCellData = .init(range: yearData, newPosition: newYearRange)
        
        let genres = LocalDB.db.filter.allGenres
        let ignoredList = LocalDB.db.filter.ignoredGenres
        let ganrs : [CollectionCellData.ColldetionData] = genres.compactMap({
            return .init(name: $0, ignored: ignoredList[$0] ?? false)
        })

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
    var changed:Bool = false

}


extension SideBarVC {
    func newImdbRange(_ newValue:(Double, Double)) {
        changed = true
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let new:LocalDB.Filter.Rating = .init(from: newValue.0, to: newValue.1)
            let old = LocalDB.db.filter.imdbRating
            if self.newRating(new: new, old: old, decimalsCount: 1) {
                LocalDB.db.filter.imdbRating = new
            }
        }
    }
    
    func newYearRange(_ newValue:(Double, Double)) {
        changed = true
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let new:LocalDB.Filter.Rating = .init(from: newValue.0, to: newValue.1)
            let old = LocalDB.db.filter.yearRating
            if self.newRating(new: new, old: old, decimalsCount: 0) {
                LocalDB.db.filter.yearRating = new
            }
        }
    }
    
    func genreSelected(_ at:Int) {
        changed = true
        print(#function, ": ", at)
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let genres = LocalDB.db.filter.allGenres
            
            let igoneredList = LocalDB.db.filter.ignoredGenres
            let ignored = igoneredList[genres[at]] ?? false
            LocalDB.db.filter.ignoredGenres.updateValue(!ignored, forKey: genres[at])
            self.getData()
            DispatchQueue.main.async {
                self.vibrate(style: .soft)
            }
        }
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


extension SideBarVC {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
    }
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    static func configure() -> SideBarVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SideBarVC") as! SideBarVC
        return vc
    }
}
