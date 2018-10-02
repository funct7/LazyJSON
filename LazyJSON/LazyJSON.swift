//
//  LazyJSON.swift
//  LazyJSON
//
//  Created by Joshua Park on 01/10/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import Foundation

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
    
    func numberValue() throws -> NSNumber {
        let (json, keyPath) = try eval()
        
        guard let number = json.number else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: NSNumber.self
            )
        }
        
        return number
    }
    
    func intValue() throws -> Int {
        let (json, keyPath) = try eval()
        
        guard let int = json.int else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: Int.self
            )
        }
        
        return int
    }
    
    func doubleValue() throws -> Double {
        let (json, keyPath) = try eval()

        guard let double = json.double else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: Double.self
            )
        }
        
        return double
    }
    
    func boolValue() throws -> Bool {
        let (json, keyPath) = try eval()
        
        guard let bool = json.bool else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: Bool.self
            )
        }
        
        return bool
    }
    
    func stringValue() throws -> String {
        let (json, keyPath) = try eval()
        
        guard let string = json.string else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: String.self
            )
        }
        
        return string
    }
    
    func arrayValue() throws -> JSONIndexedContainer {
        let (json, keyPath) = try eval()
        
        guard let array = json.array else {
            throw JSONError.invalidType(
                keyPath: keyPath,
                type: JSONIndexedContainer.self
            )
        }
        
        return array
    }
    
    func dictionaryValue() throws -> JSONKeyedContainer {
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
