//
//  JSONError.swift
//  ValidJSON
//
//  Created by Joshua Park on 28/09/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import Foundation

public enum JSONError : LocalizedError {
    
    /// The specified key does not exist.
    case keyNotFound(id: String)
    
    /// The key-value pair exists,
    /// but the value type is different than the specified type.
    case invalidType(id: String, type: JSONType.Type)
    
    public var errorDescription: String? {
        switch self {
            
        case .keyNotFound:
            return "The given key is not found."
            
        case .invalidType:
            return "The given value type is not valid."
            
        }
    }
    
}
