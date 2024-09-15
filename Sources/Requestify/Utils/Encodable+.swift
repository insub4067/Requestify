//
//  File.swift
//  
//
//  Created by 김인섭 on 9/15/24.
//

import Foundation

public extension Encodable {
    
    var jsonObject: [String: Any] {
        return try! JSONSerialization.jsonObject(with: self.data) as! [String: Any]
    }
    
    var data: Data {
        try! JSONEncoder().encode(self)
    }
}
