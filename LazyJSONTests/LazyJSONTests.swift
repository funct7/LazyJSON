//
//  LazyJSONTests.swift
//  ValidJSONTests
//
//  Created by Joshua Park on 28/09/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import XCTest
@testable import LazyJSON

fileprivate extension Optional.Key {
    
    static var foo: JSON.Key { return JSON.Key(rawValue: "foo")! }
    
    static var bar: JSON.Key { return JSON.Key(rawValue: "bar")! }
    
    static var baz: JSON.Key { return JSON.Key(rawValue: "baz")! }
    
}

class LazyJSONTests: XCTestCase {
    
    func testValidKeyInvalidType() {
        let dic: [String : JSONType] = [
            "foo" : 20,
            "bar" : ["string"],
            ]
        
        let json = LazyJSON(dic)
        
        XCTAssertEqual(20, try json[.foo].numberValue())
        
        XCTAssertEqual(20, try json[.foo].intValue())
        
        XCTAssertThrowsError(try json[.foo].doubleValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "foo")
                XCTAssertTrue(type == Double.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[.foo].boolValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "foo")
                XCTAssertTrue(type == Bool.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[.foo].stringValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "foo")
                XCTAssertTrue(type == String.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[.foo].arrayValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "foo")
                XCTAssertTrue(type == JSONIndexedContainer.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[.foo].dictionaryValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "foo")
                XCTAssertTrue(type == JSONKeyedContainer.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertEqual(["string"], try json[.bar].arrayValue() as? [String])
        XCTAssertEqual("string", try json[.bar][0].stringValue())
    }
    
    func testValidIndexInvalidType() {
        let arr: [JSONType] = [
            ["foo": 10,],
            ["bar": 20.0,],
            ["baz": ["baz" : "string"]]
            ]
        
        let json = LazyJSON(arr)
        
        XCTAssertEqual(try json[0][.foo].numberValue(), 10)
        XCTAssertEqual(try json[0][.foo].intValue(), 10)
        
        XCTAssertThrowsError(try json[0][.foo].doubleValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "\\0.foo")
                XCTAssertTrue(type == Double.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[0][.foo].boolValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "\\0.foo")
                XCTAssertTrue(type == Bool.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[0][.foo].stringValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "\\0.foo")
                XCTAssertTrue(type == String.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[0][.foo].arrayValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "\\0.foo")
                XCTAssertTrue(type == JSONIndexedContainer.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[0][.foo].dictionaryValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "\\0.foo")
                XCTAssertTrue(type == JSONKeyedContainer.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertEqual(try json[1][.bar].numberValue(), 20.0)
        
        XCTAssertThrowsError(try json[1][.bar].intValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "\\1.bar")
                XCTAssertTrue(type == Int.self)
            } else {
                XCTFail("\($0)")
            }
        }

        XCTAssertEqual(try json[1][.bar].doubleValue(), 20.0)
        
        XCTAssertThrowsError(try json[1][.bar].boolValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "\\1.bar")
                XCTAssertTrue(type == Bool.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[1][.bar].stringValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "\\1.bar")
                XCTAssertTrue(type == String.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[1][.bar].arrayValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "\\1.bar")
                XCTAssertTrue(type == JSONIndexedContainer.self)
            } else {
                XCTFail("\($0)")
            }
        }
        
        XCTAssertThrowsError(try json[1][.bar].dictionaryValue()) {
            if case .invalidType(let key, let type)? = $0 as? JSONError {
                XCTAssertEqual(key, "\\1.bar")
                XCTAssertTrue(type == JSONKeyedContainer.self)
            } else {
                XCTFail("\($0)")
            }
        }

    }
    
    func testInvalidKey() {
        let dic: [String : JSONType] = [
            "foo" : 20,
            "bar" : ["string"],
            ]
        
        do {
            let json = LazyJSON(dic)
            
            XCTAssertThrowsError(try json[.baz].intValue()) {
                if case .keyNotFound(let key)? = $0 as? JSONError {
                    XCTAssertEqual(key, "baz")
                } else {
                    XCTFail("\($0)")
                }
            }
        }
        
        let arr: [JSONType] = [
            ["foo": 10,],
            ["bar": 20,],
            ]
        
        do {
            let json = LazyJSON(arr)
            
            XCTAssertThrowsError(try json[0][.bar].dictionaryValue()) {
                if case .keyNotFound(let key)? = $0 as? JSONError {
                    XCTAssertEqual(key, "\\0.bar")
                } else {
                    XCTFail("\($0)")
                }
            }
        }
    }
    
    func testInvalidIndex() {
        let dic: [String : JSONType] = [
            "foo" : 20,
            "bar" : ["string"],
            ]
        
        do {
            let json = LazyJSON(dic)
            
            XCTAssertThrowsError(try json[.bar][1].doubleValue()) {
                if case .keyNotFound(let key)? = $0 as? JSONError {
                    XCTAssertEqual(key, "bar.\\1")
                } else {
                    XCTFail("\($0)")
                }
            }
        }
        
        let arr: [JSONType] = [
            ["foo": 10,],
            ["bar": 20,],
        ]
        
        do {
            let json = LazyJSON(arr)
            
            XCTAssertThrowsError(try json[2][.foo].doubleValue()) {
                if case .keyNotFound(let key)? = $0 as? JSONError {
                    XCTAssertEqual(key, "\\2")
                } else {
                    XCTFail("\($0)")
                }
            }
        }
    }
    
}


