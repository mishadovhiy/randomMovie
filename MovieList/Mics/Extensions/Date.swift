//
//  Date.swift
//  MovieList
//
//  Created by Misha Dovhiy on 06.05.2022.
//

import UIKit

extension Date {
    var components:DateComponents {
        return NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    }
    
    var differenceFromNow: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
    }
}
