//
//  StreamMovieVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 20.04.2024.
//

import UIKit
import WebKit

class StreamMovieVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var movie:Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        if let url:URL = .init(string: Keys.movieStreamURL + movie.imdbid),
           movie.imdbid != "" {
            webView.load(.init(url: url))
        } else {
            print("cannot load movie")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.shared?.banner.hide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppDelegate.shared?.banner.appeare()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension StreamMovieVC:UIWebViewDelegate, WKUIDelegate {
    
    
}

extension StreamMovieVC {
    static func configure(movie:Movie) -> StreamMovieVC {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StreamMovieVC") as! StreamMovieVC
        vc.movie = movie
        return vc
    }
}
