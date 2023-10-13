//
//  Data.swift
//  MovieList
//
//  Created by Misha Dovhiy on 13.10.2023.
//

import Foundation

extension Data {
    var array: NSArray? {
        var jsonResult:NSArray?
        let dataa = self
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: dataa, options:.allowFragments) as? NSArray ?? []
        } catch _ as NSError {
            return nil
        }
        return jsonResult
    }
}

