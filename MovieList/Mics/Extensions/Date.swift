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
}
