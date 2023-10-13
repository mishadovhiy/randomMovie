//
//  String.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

extension String {
    init(decimalsCount:Int, from double:Double) {
        self.init(format: "%.\(decimalsCount)f", double)
    }
    
    var json:[String: Any]? {
        let str = self.replacingOccurrences(of: "\n", with: "")
        let data = Data(str.utf8)
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : []) as? [String:Any]
            {
               print(jsonArray) // use the json here
                return jsonArray
            } else {
                print("bad json")
                return nil
            }
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    
    
}

