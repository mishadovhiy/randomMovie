//
//  Unparce.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class Unparce {
    static func json(_ jsonResult:[String:Any]) -> [Movie]? {
        guard let arrey = jsonResult["results"] as? NSArray else {
            return nil
        }
        var result:[Movie] = []
        for i in 0..<arrey.count {
            if let jsonElement = arrey[i] as? NSDictionary {
                if let dict = jsonElement as? [String : Any] {
                    result.append(.init(dict: dict))
                }
            }
        }
        return result
    }
}
