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
    
    let object: Optional<Any>
    
    private var list = [Operation]()
    
    // TODO: Use identifier to identify which API the JSON originates from.
    public init<T>(_ object: T?) {
        if let object = object {
            self.object = .some(object)
        } else {
            self.object = .none
        }
    }
    
    public subscript(key: JSON.Key) -> LazyJSON {
        get {
            var copy = self
            copy.list += [.key(key)]
            return copy
        }
    }
    
    public subscript(key: String) -> LazyJSON {
        get {
            return self[JSON.Key(key)]
        }
    }
    
    public subscript(index: Int) -> LazyJSON {
        get {
            var copy = self
            copy.list += [.index(index)]
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
                type: NSNumber.self)
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
                type: Int.self)
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
                type: Double.self)
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
                type: Bool.self)
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
                type: String.self)
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
                type: JSONIndexedContainer.self)
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
                type: JSONKeyedContainer.self)
        }
        
        return dictionary
    }
    
    public var any: Any? {
        do {
            return try eval().0 as Any
        } catch {
            return nil
        }
    }
    
    public func anyValue() throws -> Any {
        let (any, keyPath) = try eval()
        
        guard let some = any else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: Any.self)
        }
        
        return some
    }
    
    private func eval() throws -> (JSON, String) {
        var keyPath = [String]()
        
        let result = try list.reduce(object) {
            switch $1 {
            case .key(let key):
                guard $0 != nil else {
                    throw JSONError.keyNotFound(keyPath: keyPath.joined(separator: "."))
                }
                guard let keyedContainer = $0 as? JSONKeyedContainer else {
                    throw JSONError.invalidType(
                        keyPath: keyPath.joined(separator: "."),
                        type: JSONKeyedContainer.self)
                }
                
                keyPath.append(key.rawValue)
                
                guard let item = keyedContainer[key.rawValue] else {
                    throw JSONError.keyNotFound(keyPath: keyPath.joined(separator: "."))
                }
                
                return item
                
            case .index(let index):
                guard $0 != nil else {
                    throw JSONError.keyNotFound(keyPath: keyPath.joined(separator: "."))
                }
                guard let indexedContainer = $0 as? JSONIndexedContainer else {
                    throw JSONError.invalidType(
                        keyPath: keyPath.joined(separator: "."),
                        type: JSONIndexedContainer.self)
                }
                
                keyPath.append("\\\(index)")
                
                guard indexedContainer.indices.contains(index) else {
                    throw JSONError.keyNotFound(keyPath: keyPath.joined(separator: "."))
                }
                
                return indexedContainer[index]
            }
        }
        
        return (result, keyPath.joined(separator: "."))
    }
    
}
