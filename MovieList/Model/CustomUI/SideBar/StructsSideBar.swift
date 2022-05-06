//
//  StructsSideBar.swift
//  MovieList
//
//  Created by Misha Dovhiy on 06.05.2022.
//

import UIKit

extension SideBar {
    struct TableData {
        let cells: Any
        let title: String
      //  let hidden: Bool
    }
    
    struct SliderCellData {
        let range:RangeSliderView
        let newPosition: ((Double, Double)) -> ()
    }
    
    struct CollectionCellData {
        let collectionData:[ColldetionData]
        let selected: (Int) -> ()
        
        struct ColldetionData {
            let name:String
        }
    }
    
}
