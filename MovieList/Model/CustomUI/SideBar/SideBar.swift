//
//  SideBar.swift
//  Budget Tracker
//
//  Created by Mikhailo Dovhyi on 06.12.2021.
//  Copyright © 2021 Misha Dovhiy. All rights reserved.
//

import UIKit

class SideBar: UIView {
    
    var tableData:[TableData] = []
    let sectionsBeforeData = 1
    
    func getData(){

        let imdbData:RangeSliderView = .init(min: 4, max: 10,
                                             selectedMin: LocalDB.Filter.imdbRating.from,
                                             selectedMax: LocalDB.Filter.imdbRating.to,
                                             digitsCount: 1)
        let imdbCell:SliderCellData = .init(range: imdbData, newPosition: newImdbRange(_:))
        

        let yearData:RangeSliderView = .init(min: 1980, max: 2022,
                                             selectedMin: LocalDB.Filter.yearRating.from,
                                             selectedMax: LocalDB.Filter.yearRating.to,
                                             digitsCount: 0)
        let yearCell:SliderCellData = .init(range: yearData, newPosition: newYearRange(_:))
        
        let genres = ["one", "two", "three four", "five", "six", "seven", "ten", "nine", "eleven", "twelve", "theretheen"]
        var ganrs : [CollectionCellData.ColldetionData] = []
        for ganr in genres {
            ganrs.append(.init(name: ganr))
        }
        let genresCell:CollectionCellData = .init(collectionData: ganrs, selected: genreSelected(_:))
        
        tableData = [
            .init(cells: imdbCell, title: "imdb rating"),
            .init(cells: yearCell, title: "year range"),
            .init(cells: genresCell, title: "genre")
        ]
        
        DispatchQueue.main.async {
            ViewController.shared?.sideBarTable.reloadData()
        }
    }
    


    
    func load() {
        if ViewController.shared?.sideBarTable.delegate == nil {
            ViewController.shared?.sideBarTable.delegate = self
            ViewController.shared?.sideBarTable.dataSource = self
        }
    }
    
    
    
    

    
}



extension SideBar {
    func newImdbRange(_ newValue:(Double, Double)) {
        print(#function, ": ", newValue)
        LocalDB.Filter.imdbRating = .init(from: newValue.0, to: newValue.1)
    }
    
    func newYearRange(_ newValue:(Double, Double)) {
        print(#function, ": ", newValue)
        LocalDB.Filter.yearRating = .init(from: newValue.0, to: newValue.1)
    }
    
    func genreSelected(_ at:Int) {
        
    }
}
