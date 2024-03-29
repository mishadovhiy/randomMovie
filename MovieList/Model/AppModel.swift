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
    static var appBundle:String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}



extension AppModel {
    struct Present {
        static func movieList(_ vc:UIViewController, type:MovieListVC.ScreenType) {
            let newVC = MovieListVC.configure(type: type)
            vc.navigationController?.pushViewController(newVC, animated: true)
            vc.navigationController?.setNavigationBarHidden(false, animated:true)
        }
    }
}



extension AppModel {
    struct Appearence {
        static var message:MessageViewLibrary = {
            return MessageViewLibrary.instanceFromNib()
        }()
        
        static var alert:AlertManager {
            return AppDelegate.shared?.ai ?? .init()
        }
    }
    
    
}
