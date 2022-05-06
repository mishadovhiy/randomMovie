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
        
        tableData = [
            .init(cells: imdbCell, title: "imdb rating", hidden: false),
            .init(cells: yearCell, title: "year range", hidden: false)
        ]
        
        DispatchQueue.main.async {
            ViewController.shared?.sideBarTable.reloadData()
        }
    }
    


    
    func load() {
        DispatchQueue.main.async {
            if ViewController.shared?.sideBarTable.delegate == nil {
                ViewController.shared?.sideBarTable.delegate = self
                ViewController.shared?.sideBarTable.dataSource = self
            }
            
        }
        getData()
    }
    
    
    

    struct TableData {
        let cells: Any
        let title: String
        let hidden: Bool
    }
    
    struct SliderCellData {
        let range:RangeSliderView
        let newPosition: ((Double, Double)) -> ()
    }
    
    struct CollectionCellData {
        let collectionData:[String]
        let selected: (Int) -> ()
    }
}


