//
//  AppModel.swift
//  MovieList
//
//  Created by Misha Dovhiy on 08.05.2022.
//

import UIKit
import AlertViewLibrary
import MessageViewLibrary

struct AppModel {
    static var mySqlMovieList:Data?
}



extension AppModel {
    struct Present {
        static func movieList(_ vc:UIViewController, type:MovieListVC.ScreenType) {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newVC = storyboard.instantiateViewController(withIdentifier: "MovieList") as! MovieListVC
                newVC.screenType = type
                newVC.modalPresentationStyle = .formSheet
                vc.present(newVC, animated: true)

            }
        }
    }
}



extension AppModel {
    struct Appearence {
        static var message:MessageViewLibrary = {
            return MessageViewLibrary.instanceFromNib()
        }()
        
        static var ai:AlertViewLibrary = {
            let ai = AlertViewLibrary.instanceFromNib()
            return ai
        }()
    }
    
    
}
