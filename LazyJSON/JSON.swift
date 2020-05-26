//
//  JSON.swift
//  ValidJSON
//
//  Created by Joshua Park on 28/09/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import Foundation
/**
 An `Optional` type extension for `JSONType`s.
 
 While this type provides easy access to values at key paths,
 the client cannot determine which key-value pair is invalid.
 
 In order to get debug information on where the operation went wrong,
 use `LazyJSON` instead.
 */
public typealias JSON = Optional<Any>

extension Optional where Wrapped == Any {
    
    /**
     The type encapsulating the string key that is used to access the value.
     
     Clients of `JSON` are expected to extend this type like the following code:
     ```
     extension Optional.Key {
     
     static var foo: JSON.Key { return JSON.Key(rawValue: "foo")! }
     
     }
     ```
     */
    public struct Key: RawRepresentable {
        
        public var rawValue: String
        
        public init?(rawValue: String) { self.rawValue = rawValue }
        
        public init(_ rawValue: String) { self.rawValue = rawValue }
        
    }

}

extension Optional where Wrapped == Any {
    
    public subscript(key: Optional.Key) -> JSON {
        get { return self[key.rawValue] }
        // TODO: Test this
        set { self[key.rawValue] = newValue }
    }
    
    public subscript(key: String) -> JSON {
        get {
            if let val = self,
                let object = val as? JSONKeyedContainer,
                let value = object[key]
            {
                return Optional(value)
            } else {
                return .none
            }
        }
        // TODO: Test this
        set {
            guard case .some(let val) = self,
                var object = val as? JSONKeyedContainer
                else { return }
            
            if let newValue = newValue {
                object[key] = newValue
            } else {
                object.removeValue(forKey: key)
            }
            
            self = Optional(object)
        }
    }
    
    public subscript(index: Int) -> JSON {
        get {
            if case .some(let val) = self,
                let object = val as? JSONIndexedContainer,
                index < object.count
            {
                return Optional(object[index])
            } else {
                return .none
            }
        }
        // TODO: Test this
        set {
            guard case .some(let val) = self,
                  var object = val as? JSONIndexedContainer,
                  index < object.count
            else { return }
            
            if let newValue = newValue {
                object[index] = newValue
            } else {
                object.remove(at: index)
            }
            
            self = Optional(object)
        }
    }
    
}

extension Optional where Wrapped == Any {
    
    /**
     Returns an `Int` value at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    public var int: Int? { return getValue() }
    
    /**
     Returns a `Double` value at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    public var double: Double? { return getValue() }
    
    /**
     Returns an `NSNumber` value at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    public var number: NSNumber? { return getValue() }
    
    
    /**
     Returns a `Bool` value at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    public var bool: Bool? { return getValue() }
    
    /**
     Returns a `String` value at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    public var string: String? { return getValue() }
    
    /**
     Returns an array of `JSONType`s at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    public var array: JSONIndexedContainer? { return getValue() }
    
    /**
     Returns a `JSONKeyedContainer` object at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    public var json: JSONKeyedContainer? { return getValue() }
    
    private func getValue<T>() -> T? {
        guard let value = self,
              let result = value as? T
        else { return nil }
        
        return result
    }
    
}


