//
//  AppModel.swift
//  MovieList
//
//  Created by Misha Dovhiy on 08.05.2022.
//

import UIKit

struct AppModel {
    static var message:MessageView = {
        return MessageView.instanceFromNib() as! MessageView
    }()
}
