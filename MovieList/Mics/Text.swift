//
//  Constance.swift
//  MovieList
//
//  Created by Misha Dovhiy on 09.05.2022.
//

import UIKit

struct Text {
    struct Colors {
        static let blackGrey = UIColor(named: "BlackGreyColor") ?? .black
        static let darkGrey = UIColor(named: "DarkGreyColor") ?? .black
        static let lightGrey = UIColor(named: "LightGreyColor") ?? .black
        static let primaryBackground = UIColor(named: "PimaryBackgroundColor") ?? .black
        static let purpure = UIColor(named: "PurpureColor") ?? .black
        static let secondaryBacground = UIColor(named: "SecondaryBacgroundColor") ?? .black
        static let white = UIColor(named: "WhiteColor") ?? .black
    }
}


struct Styles {
    static let buttonShadow:Float = 0.3
    static let buttonPressedComponentDelta:CGFloat = 0.01
    static let viewPressedComponentDelta:CGFloat = 0.25
    static let pressedAnimation:CGFloat = 0.2
    static let opacityBackground:CGFloat = 0.15
    static let buttonRadius:CGFloat = 5
    static let buttonRadius2:CGFloat = 9
    static let buttonRadius3:CGFloat = 12
}
