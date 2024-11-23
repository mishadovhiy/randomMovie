//
//  String.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.05.2022.
//

import UIKit

extension String {
    func substring(between start: String, and end: String) -> String? {
        let pattern = "\(start)(.*?)\(end)"
        if self.isEmpty {
            return nil
        }
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(self.startIndex..<self.endIndex, in: self)
            
            if let match = regex.firstMatch(in: self, options: [], range: range) {
                if let range = Range(match.range(at: 1), in: self) {
                    return String(self[range])
                }
            }
        } catch {
            print("Invalid regular expression: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    var toByteData:Data? {
      return Data(self.split(separator: ",").compactMap({UInt8($0)}))
    }
    
    var toDict:[String:Any]? {
        return Data(self.utf8).toDict
    }
    
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

