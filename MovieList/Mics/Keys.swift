//
//  Keys.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

struct Keys {
    static let apiKey = "77eb2877e4msh9e213a3cbcb9f58p1b5b3djsn82dd3c2c1d14"
    static let apiURL = "https://ott-details.p.rapidapi.com/"
    //"https://k2maan-moviehut.herokuapp.com/api/"
    static let sqlURL = "https://mishadovhiy.com/apps/other-apps-db/moviesDB/"
    static let sqlKey = "44fdcv8jf3"
    static let apiDefaultParameters = "&type=movie" + "&genre=romance, action, comedy, horror, action, sci-fi, triller, fantasy, drama, family, western, crime, mystery, fiction, disaster, adventure" + "&min_imdb=4" + "&start_year=1980" + "&sort=oldest&page="
    static let movieStreamURL = "https://vidsrc.net/embed/"
}
