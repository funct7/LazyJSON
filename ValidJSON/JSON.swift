//
//  JSON.swift
//  ValidJSON
//
//  Created by Joshua Park on 28/09/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import Foundation

///**
// A wrapper for a valid JSON dictionary.
// */
//struct JSON: JSONType {
//
//    /**
//     A structure to use as the key.
//
//     Extend this type and provide custom static variables.
//     */
//    struct Key: RawRepresentable {
//
//        var rawValue: String
//
//        init?(rawValue: String) {
//            self.rawValue = rawValue
//        }
//
//    }
//
////    public static func +(lhs: JSON, rhs: JSON) -> JSON {
////        var data = lhs.dictionary
////        for (key, value) in rhs.dictionary {
////            data[key] = value
////        }
////        return JSON(map: data)
////    }
//
//    /**
//     The identifier for the JSON object.
//
//     When an error is thrown, the identifer is passed
//     into the relevant `JSONError` associated value.
//     This identifier can be used to identify the data
//     where the error came from.
//     */
//    let identifier: String?
//
//    fileprivate var object: JSONType
//
//    init(identifier: String? = nil,
//         object: JSONType)
//    {
//        self.identifier = identifier
//        self.object = object
//    }
//
////    public mutating func merge(map otherMap: [String: Any]?) {
////        guard let otherMap = otherMap else { return }
////
////        for (key, value) in otherMap {
////            self.dictionary[key] = value
////        }
////    }
//
////    func int(_ key: String) throws -> Int {
////        guard let value = dictionary[key] else {
////            throw JSONError.keyNotFound(
////                id: identifier,
////                type: .int(key: key)
////            )
////        }
////
////        guard let int = value as? Int else {
////            throw JSONError.invalidType(
////                id: identifier,
////                type: .int(key: key)
////            )
////        }
////
////        return int
////    }
////
////    func double(_ key: String) throws -> Double {
////        guard let value = dictionary[key] else {
////            throw JSONError.keyNotFound(
////                id: identifier,
////                type: .double(key: key)
////            )
////        }
////        guard let double = value as? Double else {
////            throw JSONError.invalidType(
////                id: identifier,
////                type: .double(key: key)
////            )
////        }
////
////        return double
////    }
////
////    func str(_ key: String) throws -> String {
////        guard let value = dictionary[key] else {
////            throw JSONError.keyNotFound(
////                id: identifier,
////                type: .string(key: key)
////            )
////        }
////        guard let string = value as? String else {
////            throw JSONError.invalidType(
////                id: identifier,
////                type: .string(key: key)
////            )
////        }
////
////        return string
////    }
////
////    func nonEmptyStr(_ key: String) throws -> String {
////        guard let value = dictionary[key] else {
////            throw JSONError.keyNotFound(
////                id: identifier,
////                type: .nonNilString(key: key)
////            )
////        }
////
////        guard let string = value as? String, string.count > 0 else {
////            throw JSONError.invalidType(
////                id: identifier,
////                type: .nonNilString(key: key)
////            )
////        }
////
////        return string
////    }
////
////    func bool(_ key: String) throws -> Bool {
////        guard let value = dictionary[key] else {
////            throw JSONError.keyNotFound(
////                id: identifier,
////                type: .bool(key: key)
////            )
////        }
////        guard let bool = value as? Bool else {
////            throw JSONError.invalidType(
////                id: identifier,
////                type: .bool(key: key)
////            )
////        }
////
////        return bool
////    }
////
////    func map(_ key: String) throws -> [String : Any] {
////        guard let value = dictionary[key] else {
////            throw JSONError.keyNotFound(
////                id: identifier,
////                type: .map(key: key, type: .any)
////            )
////        }
////        guard let map = value as? [String : Any] else {
////            throw JSONError.invalidType(
////                id: identifier,
////                type: .map(key: key, type: .any)
////            )
////        }
////
////        return map
////    }
////
////    func arr(_ key: String) throws -> [Any] {
////        guard let array = self.map[key] as? [Any] else {
////            throw NSError.invalidDataStructure(dataType: T.self,
////                                               key: key,
////                                               valueType: [Any].self)
////        }
////        return array
////    }
////
////    func dicArr(_ key: String) throws -> [JSON] {
////        guard let dicArr = self.map[key] as? [[String: Any]] else {
////            throw NSError.invalidDataStructure(dataType: T.self,
////                                               key: key,
////                                               valueType: [[String: Any]].self)
////        }
////        return dicArr.map { JSON($0) }
////    }
//
////    public func get(_ key: String) -> Any? {
////        return self.dictionary[key]
////    }
////
////    public subscript(key: String) -> Any? {
////        get {
////            return self.dictionary[key]
////        }
////        set {
////            self.dictionary[key] = newValue
////        }
////    }
////
////
////    public var keys: Dictionary<String, Any>.Keys {
////        return dictionary.keys
////    }
////
////    public var values: Dictionary<String, Any>.Values {
////        return dictionary.values
////    }
//
//}
//
//extension JSON {
//
//    subscript(key: Key) -> Wrapper {
//        get {
//            if let object = object as? JSONKeyedContainer {
//                return Wrapper(object: object[key.rawValue])
//            } else {
//                return Wrapper.none
//            }
//        }
//        set {
//            if var object = object as? JSONKeyedContainer {
//                object[key.rawValue] = newValue
//                self.object = Wrapper(object: object)
//            }
//        }
//    }
//
//    subscript(index: Int) -> Wrapper {
//        get {
//            if let object = object as? JSONIndexedContainer {
//                return Wrapper(object: object[index])
//            } else {
//                return Wrapper.none
//            }
//        }
//        set {
//            if var object = object as? JSONIndexedContainer {
//                object[index] = newValue
//                self.object = Wrapper(object: object)
//            }
//        }
//    }
//
//    subscript(key: JSONKey) -> Wrapper {
//        get {
//            switch key {
//
//            case .index(let index):
//                guard let object = object as? JSONIndexedContainer
//                else { return .none }
//
//                // TODO: Insert out of bounds check.
//                return Wrapper(object: object[index])
//
//            case .key(let key):
//                guard let object = object as? JSONKeyedContainer
//                else { return .none }
//
//                return Wrapper(object: object[key])
//            }
//        }
//        set {
//            switch key {
//
//            case .index(let index):
//                guard var object = object as? JSONIndexedContainer
//                else { return }
//
//                object[index] = newValue
//                self.object = object
//
//            case .key(let key):
//                guard var object = object as? JSONKeyedContainer
//                else { return }
//
//                object[key] = newValue
//                self.object = object
//            }
//        }
//    }
//
//}

/**
 A lightweight wrapper for JSON objects.
 
 While this type provides easy access to values at key paths,
 the client cannot determine which key-value pair is invalid.
 
 In order to get debug information on where the operation went wrong,
 use `LazyJSON` instead.
 */
enum JSON : JSONType {
    
    /**
     The type encapsulating the string key that is used to access the value.
     
     Clients of `JSON` are expected to extend this type like the following code:
     ```
     extension JSON.Key {
     
        static var foo: JSON.Key { return JSON.Key(rawValue: "foo")! }
     
     }
     ```
     */
    struct Key: RawRepresentable {
        
        var rawValue: String
        
        init?(rawValue: String) { self.rawValue = rawValue }
        
    }

    case some(JSONType)
    
    case none
    
    // TODO: Use identifier.
    /**
     Initializes the JSON object.
     
     - Todo: Use identifier to identify APIs.
     
     - Parameters:
        - identifier: A unique ID used to identify the JSON object.
        - object: The JSON object to encapsulate.
     */
    init(identifier: String? = nil,
         object: JSONType?)
    {
        if let object = object {
            self = .some(object)
        } else {
            self = .none
        }
    }
    
}

extension JSON {
    
    subscript(key: JSON.Key) -> JSON {
        get {
            if case .some(let val) = self,
               let object = val as? JSONKeyedContainer
            {
                return JSON(object: object[key.rawValue])
            } else {
                return .none
            }
        }
        set {
            guard case .some(let val) = self,
                  var object = val as? JSONKeyedContainer
            else { return }
            
            object[key.rawValue] = newValue
            self = JSON(object: object)
        }
    }
    
    subscript(index: Int) -> JSON {
        get {
            if case .some(let val) = self,
               let object = val as? JSONIndexedContainer
            {
                return JSON(object: object[index])
            } else {
                return .none
            }
        }
        set {
            guard case .some(let val) = self,
                  var object = val as? JSONIndexedContainer
            else { return }
            
            object[index] = newValue
            self = JSON(object: object)
        }
    }
    
}

extension JSON {
    
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
        guard case .some(let value) = self,
              let result = value as? T
        else { return nil }
        
        return result
    }
    
}

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
