//
//  NSArray.swift
//  MovieList
//
//  Created by Misha Dovhiy on 13.10.2023.
//

import Foundation

extension NSArray {
    func data(dictKey:String) -> [(Data?, [String:Any]?)]? {

        return self.compactMap({
            if let jsonElement = $0 as? NSDictionary,
               let dict = jsonElement as? [String : Any],
               let resultString = dict[dictKey] as? String
            {
                return (Data(base64Encoded: resultString, options: .ignoreUnknownCharacters), dict)
            } else {
                return (nil, nil)
            }
        })
    }
}
