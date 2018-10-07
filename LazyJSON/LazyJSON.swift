//
//  LazyJSON.swift
//  LazyJSON
//
//  Created by Joshua Park on 01/10/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import Foundation

enum Operation {
    
    case key(JSON.Key)
    
    case index(Int)
    
}

public struct LazyJSON {
    
    let object: JSON
    
    private var list = [Operation]()
    
    // TODO: Use identifier to identify which API the JSON originates from.
    public init<T: Any>(_ object: T?) {
        if let object = object {
            self.object = .some(object as Any)
        } else {
            self.object = .none
        }
    }
    
    public subscript(key: JSON.Key) -> LazyJSON {
        get {
            var copy = self
            copy.list += [Operation.key(key)]
            return copy
        }
    }
    
    public subscript(index: Int) -> LazyJSON {
        get {
            var copy = self
            copy.list += [Operation.index(index)]
            return copy
        }
    }
    
    public var number: NSNumber? {
        do {
            let (json, _) = try eval()
            return json as? NSNumber
        }
        catch { return nil }
    }
    
    public func numberValue() throws -> NSNumber {
        let (json, keyPath) = try eval()
        
        guard let number = json.number else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: NSNumber.self
            )
        }
        
        return number
    }
    
    public var int: Int? {
        do {
            let (json, _) = try eval()
            return json as? Int
        }
        catch { return nil }
    }
    
    public func intValue() throws -> Int {
        let (json, keyPath) = try eval()
        
        guard let int = json.int else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: Int.self
            )
        }
        
        return int
    }
    
    public var double: Double? {
        do {
            let (json, _) = try eval()
            return json as? Double
        }
        catch { return nil }
    }
    
    public func doubleValue() throws -> Double {
        let (json, keyPath) = try eval()

        guard let double = json.double else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: Double.self
            )
        }
        
        return double
    }
    
    public var bool: Bool? {
        do {
            let (json, _) = try eval()
            return json as? Bool
        }
        catch { return nil }
    }
    
    public func boolValue() throws -> Bool {
        let (json, keyPath) = try eval()
        
        guard let bool = json.bool else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: Bool.self
            )
        }
        
        return bool
    }
    
    public var string: String? {
        do {
            let (json, _) = try eval()
            return json as? String
        }
        catch { return nil }
    }
    
    public func stringValue() throws -> String {
        let (json, keyPath) = try eval()
        
        guard let string = json.string else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: String.self
            )
        }
        
        return string
    }
    
    public var array: JSONIndexedContainer? {
        do {
            let (json, _) = try eval()
            return json as? JSONIndexedContainer
        }
        catch { return nil }
    }

    public func arrayValue() throws -> JSONIndexedContainer {
        let (json, keyPath) = try eval()
        
        guard let array = json.array else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: JSONIndexedContainer.self
            )
        }
        
        return array
    }
    
    public var dictionary: JSONKeyedContainer? {
        do {
            let (json, _) = try eval()
            return json as? JSONKeyedContainer
        }
        catch { return nil }
    }
    
    public func dictionaryValue() throws -> JSONKeyedContainer {
        let (json, keyPath) = try eval()
        
        guard let dictionary = json.json else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: JSONKeyedContainer.self
            )
        }
        
        return dictionary
    }
    
    // TODO: Refactor!!
    private func eval() throws -> (JSON, String) {
        var json: JSON = object
        var keyPath = ""
        
        for op in list {
            switch op {
                case .key(let key):

                    switch json {
                        
                    case .none:
                        throw JSONError.keyNotFound(keyPath: String(keyPath.dropFirst()))
                        
                    case .some(let temp):
                        if var temp = temp as? JSONKeyedContainer {
                            keyPath += ".\(key.rawValue)"
                            
                            if let temp = temp[key.rawValue] {
                                json = .some(temp)
                            } else {
                                throw JSONError.keyNotFound(keyPath: String(keyPath.dropFirst()))
                            }
                        } else {
                            throw JSONError.invalidType(
                                keyPath: String(keyPath.dropFirst()),
                                type: JSONKeyedContainer.self
                            )
                        }
                        
                    }
                    
                
                case .index(let index):
                    
                    switch json {
                        
                    case .none:
                        throw JSONError.keyNotFound(keyPath: String(keyPath.dropFirst()))
                        
                    case .some(let temp):
                        if var temp = temp as? JSONIndexedContainer {
                            keyPath += ".\\\(index)"
                            
                            if index < temp.count {
                                json = .some(temp[index])
                            } else {
                                throw JSONError.keyNotFound(keyPath: String(keyPath.dropFirst()))
                            }
                        } else {
                            throw JSONError.invalidType(
                                keyPath: String(keyPath.dropFirst()),
                                type: JSONIndexedContainer.self
                            )
                        }

                    }
            }
        }

        return (json, String(keyPath.dropFirst()))
    }
    
}
