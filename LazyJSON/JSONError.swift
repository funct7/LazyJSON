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
    case keyNotFound(keyPath: [String])
    
    /// The key-value pair exists,
    /// but the value type is different than the specified type.
    case invalidType(keyPath: [String], type: Any.Type)
    
    public var errorDescription: String? {
        switch self {
        case .keyNotFound(keyPath: let keyPath):
            return "The given key is not found.\nKeyPath: \(keyPath)"
            
        case .invalidType(keyPath: let keyPath, type: let typeToken):
            return "The given value type is not valid.\nKeyPath: \(keyPath); Type: \(typeToken)"
        }
    }
    
}
