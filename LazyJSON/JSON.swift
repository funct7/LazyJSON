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
typealias JSON = Optional<JSONType>

extension Optional where Wrapped == JSONType {
    
    /**
     The type encapsulating the string key that is used to access the value.
     
     Clients of `JSON` are expected to extend this type like the following code:
     ```
     extension Optional.Key {
     
     static var foo: JSON.Key { return JSON.Key(rawValue: "foo")! }
     
     }
     ```
     */
    struct Key: RawRepresentable {
        
        var rawValue: String
        
        init?(rawValue: String) { self.rawValue = rawValue }
        
    }

}

extension Optional where Wrapped == JSONType {
    
    subscript(key: Optional.Key) -> JSON {
        get {
            if let val = self,
               let object = val as? JSONKeyedContainer,
               let value = object[key.rawValue]
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
                object[key.rawValue] = newValue
            } else {
                object.removeValue(forKey: key.rawValue)
            }
            
            self = Optional(object)
        }
    }
    
    subscript(index: Int) -> JSON {
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

extension Optional where Wrapped == JSONType {
    
    /**
     Returns an `Int` value at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    var int: Int? { return getValue() }
    
    /**
     Returns a `Double` value at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    var double: Double? { return getValue() }
    
    /**
     Returns an `NSNumber` value at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    var number: NSNumber? { return getValue() }
    
    
    /**
     Returns a `Bool` value at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    var bool: Bool? { return getValue() }
    
    /**
     Returns a `String` value at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    var string: String? { return getValue() }
    
    /**
     Returns an array of `JSONType`s at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    var array: JSONIndexedContainer? { return getValue() }
    
    /**
     Returns a `JSONKeyedContainer` object at the specified key path.
     
     If there were any invalid keys or wrong value types
     in the key path, the returned value is `nil`.
     */
    var json: JSONKeyedContainer? { return getValue() }
    
    private func getValue<T: JSONType>() -> T? {
        guard let value = self,
              let result = value as? T
        else { return nil }
        
        return result
    }
    
}

//
///**
// A lightweight wrapper for JSON objects.
//
// While this type provides easy access to values at key paths,
// the client cannot determine which key-value pair is invalid.
//
// In order to get debug information on where the operation went wrong,
// use `LazyJSON` instead.
// */
//enum JSON : JSONType {
//
//    /**
//     The type encapsulating the string key that is used to access the value.
//
//     Clients of `JSON` are expected to extend this type like the following code:
//     ```
//     extension JSON.Key {
//
//        static var foo: JSON.Key { return JSON.Key(rawValue: "foo")! }
//
//     }
//     ```
//     */
//    struct Key: RawRepresentable {
//
//        var rawValue: String
//
//        init?(rawValue: String) { self.rawValue = rawValue }
//
//    }
//
//    case some(JSONType)
//
//    case none
//
//    // TODO: Use identifier.
//    /**
//     Initializes the JSON object.
//
//     - Todo: Use identifier to identify APIs.
//
//     - Parameters:
//        - identifier: A unique ID used to identify the JSON object.
//        - object: The JSON object to encapsulate.
//     */
//    init(identifier: String? = nil,
//         object: JSONType?)
//    {
//        if let object = object {
//            self = .some(object)
//        } else {
//            self = .none
//        }
//    }
//
//}
//
//extension JSON {
//
//    subscript(key: JSON.Key) -> JSON {
//        get {
//            if case .some(let val) = self,
//               let object = val as? JSONKeyedContainer
//            {
//                return JSON(object: object[key.rawValue])
//            } else {
//                return .none
//            }
//        }
//        set {
//            guard case .some(let val) = self,
//                  var object = val as? JSONKeyedContainer
//            else { return }
//
//            object[key.rawValue] = newValue
//            self = JSON(object: object)
//        }
//    }
//
//    subscript(index: Int) -> JSON {
//        get {
//            if case .some(let val) = self,
//               let object = val as? JSONIndexedContainer,
//               index < object.count
//            {
//                return JSON(object: object[index])
//            } else {
//                return .none
//            }
//        }
//        set {
//            guard case .some(let val) = self,
//                  var object = val as? JSONIndexedContainer
//            else { return }
//
//            object[index] = newValue
//            self = JSON(object: object)
//        }
//    }
//
//}
//
//extension JSON {
//
//    /**
//     Returns an `Int` value at the specified key path.
//
//     If there were any invalid keys or wrong value types
//     in the key path, the returned value is `nil`.
//     */
//    var int: Int? { return getValue() }
//
//    /**
//     Returns a `Double` value at the specified key path.
//
//     If there were any invalid keys or wrong value types
//     in the key path, the returned value is `nil`.
//     */
//    var double: Double? { return getValue() }
//
//    /**
//     Returns an `NSNumber` value at the specified key path.
//
//     If there were any invalid keys or wrong value types
//     in the key path, the returned value is `nil`.
//     */
//    var number: NSNumber? { return getValue() }
//
//
//    /**
//     Returns a `Bool` value at the specified key path.
//
//     If there were any invalid keys or wrong value types
//     in the key path, the returned value is `nil`.
//     */
//    var bool: Bool? { return getValue() }
//
//    /**
//     Returns a `String` value at the specified key path.
//
//     If there were any invalid keys or wrong value types
//     in the key path, the returned value is `nil`.
//     */
//    var string: String? { return getValue() }
//
//    /**
//     Returns an array of `JSONType`s at the specified key path.
//
//     If there were any invalid keys or wrong value types
//     in the key path, the returned value is `nil`.
//     */
//    var array: JSONIndexedContainer? { return getValue() }
//
//    /**
//     Returns a `JSONKeyedContainer` object at the specified key path.
//
//     If there were any invalid keys or wrong value types
//     in the key path, the returned value is `nil`.
//     */
//    var json: JSONKeyedContainer? { return getValue() }
//
//    private func getValue<T: JSONType>() -> T? {
//        guard case .some(let value) = self,
//              let result = value as? T
//        else { return nil }
//
//        return result
//    }
//
//}

protocol JSONType { }

protocol JSONElementType: JSONType { }

protocol JSONContainerType: JSONType { }

typealias JSONIndexedContainer = [JSONType]

typealias JSONKeyedContainer = [String : JSONType]

extension Dictionary : JSONType, JSONContainerType where Key == String, Value == JSONType { }

extension Array : JSONType, JSONContainerType where Element == JSONType { }

extension NSNumber : JSONType, JSONElementType { }

extension NSString : JSONType, JSONElementType { }

extension Int : JSONType, JSONElementType { }

extension Double : JSONType, JSONElementType { }

extension Bool : JSONType, JSONElementType { }

extension String : JSONType, JSONElementType { }

// Lazy evaluating JSON type
// - Have a reference to the wrapping parent.

// Alternatively
// Subscript should be recorded.
// - Any error should be also wrapped.

// Evaluation happens at the time of unwrapping the value.

/*
 [ Case 1 ]
            v
 try json[.foo][0][.bar][1].intValue()
 --> JSONError.invalidType "invalid type key: foo, value: Array"
 
 [ Case 2 ]
                     v
 try json[.foo][0][.bar][1].boolValue()
 --> JSONError.invalidKey "invalid key: bar"
 
 * queue should be returned at each step.
 
 // Case 1
 - operationQueue: [unwrap with key "foo"] [unwrap with index 0]
                                            ^ throw error here
 
 // Case 2
 - operationQueue: [unwrap with key "foo"] [unwrap with index 0] [unwrap with key "bar"]
                                                                  ^ throw error here
 var json = object
 var list = [String]()
 
 for op in list {
    swtich op {
        case .key(let key):
            if var temp = json as? Map {
                json = temp[key]
                list += key
            } else if json == nil {
                throw JSONError.invalidKey(list)
            } else {
                throw JSONError.invalidType(list, Map.self)
            }
 
        case .index(let index):
            if var temp = json as? Array {
                if index < temp.count {
                    json = temp[index]
                    list += "\(index)"
                } else {
                    throw JSONError.invalidKey(list)
                }
            } else if json == nil {
                throw JSONError.invalidKey(list)
            } else {
                throw JSONError.invalidType(list, Array.self)
            }
 
    }
 }
 
 */

enum Operation {
    
    case key(JSON.Key)
    
    case index(Int)
    
}

struct LazyJSON : JSONType {
    
    let object: JSON
    
    private var list = [Operation]()
    
    init(_ object: JSONType) {
        self.object = .some(object)
    }
    
    func intValue() throws -> Int {
        let (json, keyPath) = try eval()
        
        guard let int = json.int else {
            throw JSONError.invalidType(
                id: keyPath,
                type: Int.self
            )
        }
        
        return int
    }
    
    func doubleValue() throws -> Double {
        let (json, keyPath) = try eval()

        guard let double = json.double else {
            throw JSONError.invalidType(
                id: keyPath,
                type: Double.self
            )
        }
        
        return double
    }
    
    func stringValue() throws -> String {
        let (json, keyPath) = try eval()
        
        guard let string = json.string else {
            throw JSONError.invalidType(
                id: keyPath,
                type: String.self
            )
        }
        
        return string
    }
    
    subscript(key: JSON.Key) -> LazyJSON {
        get {
            var copy = self
            copy.list += [Operation.key(key)]
            return copy
        }
    }
    
    subscript(index: Int) -> LazyJSON {
        get {
            var copy = self
            copy.list += [Operation.index(index)]
            return copy
        }
    }
    
    private func eval() throws -> (JSON, String) {
        var json: JSON = object
        var keyPath = ""
        
        for op in list {
            switch op {
                case .key(let key):

                    switch json {
                        
                    case .none:
                        throw JSONError.keyNotFound(id: String(keyPath.dropFirst()))
                        
                    case .some(let temp):
                        if var temp = temp as? JSONKeyedContainer {
                            keyPath += ".\(key.rawValue)"
                            
                            if let temp = temp[key.rawValue] {
                                json = .some(temp)
                            } else {
                                throw JSONError.keyNotFound(id: String(keyPath.dropFirst()))
                            }
                        } else {
                            throw JSONError.invalidType(
                                id: String(keyPath.dropFirst()),
                                type: JSONKeyedContainer.self
                            )
                        }
                        
                    }
                    
                
                case .index(let index):
                    
                    switch json {
                        
                    case .none:
                        throw JSONError.keyNotFound(id: String(keyPath.dropFirst()))
                        
                    case .some(let temp):
                        if var temp = temp as? JSONIndexedContainer {
                            keyPath += ".\\\(index)"
                            
                            if index < temp.count {
                                json = .some(temp[index])
                            } else {
                                throw JSONError.keyNotFound(id: String(keyPath.dropFirst()))
                            }
                        } else {
                            throw JSONError.invalidType(
                                id: String(keyPath.dropFirst()),
                                type: JSONIndexedContainer.self
                            )
                        }

                    }
            }
        }

        return (json, String(keyPath.dropFirst()))
    }
    
}
