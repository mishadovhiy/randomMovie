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
    
    static func create(from dict:[String:Any]) -> Data? {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: false) {
            print(data.count, " gewsassd")
            return data

        } else {
            return nil
        }
    }
    
    func byteString(_ separetor:String = "") -> String? {
      return Array(self).compactMap({"\($0)"}).joined(separator: separetor)
    }
    
    var toDict:[String:Any]? {
            // Decode the binary data to a dictionary
        if let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self) as? [String: Any] {
                // Use 'dictionary' as the decoded dictionary
                return dictionary
            } else {
                
                return nil
            }
    }
}

