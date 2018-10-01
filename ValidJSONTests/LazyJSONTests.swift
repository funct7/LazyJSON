//
//  LazyJSONTests.swift
//  ValidJSONTests
//
//  Created by Joshua Park on 28/09/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import XCTest
@testable import ValidJSON

fileprivate extension JSON.Key {
    
    static var foo: JSON.Key { return JSON.Key(rawValue: "foo")! }
    
    static var bar: JSON.Key { return JSON.Key(rawValue: "bar")! }
    
    static var baz: JSON.Key { return JSON.Key(rawValue: "baz")! }
    
}

class LazyJSONTests: XCTestCase {
    
    func test() {
        let dic: [String : JSONType] = [
            "foo" : 20,
            "bar" : ["string"],
            ]
        
        do {
            let json = LazyJSON(dic)
            
            XCTAssertEqual(20, try json[.foo].intValue())
            
            XCTAssertThrowsError(try json[.foo].doubleValue()) {
                if case .invalidType(let key, let type)? = $0 as? JSONError {
                    XCTAssertEqual(key, "foo")
                    XCTAssertTrue(type == Double.self)
                } else {
                    XCTFail()
                }
            }

            XCTAssertThrowsError(try json[.baz].intValue()) {
                if case .keyNotFound(let key)? = $0 as? JSONError {
                    XCTAssertEqual(key, "baz")
                } else {
                    XCTFail()
                }
            }
            
            XCTAssertThrowsError(try json[.bar][.bar].doubleValue()) {
                if case .invalidType(let key, let type)? = $0 as? JSONError {
                    XCTAssertEqual(key, "bar")
                    XCTAssertTrue(type == JSONKeyedContainer.self)
                } else {
                    XCTFail()
                }
            }
            
            XCTAssertThrowsError(try json[.bar][0].doubleValue()) {
                if case .invalidType(let key, let type)? = $0 as? JSONError {
                    XCTAssertEqual(key, "bar.\\0")
                    XCTAssertTrue(type == Double.self)
                } else {
                    XCTFail()
                }
            }
            
            XCTAssertEqual("string", try json[.bar][0].stringValue())
        }
        
        let arr: [JSONType] = [dic]
        
        do {
            let json = LazyJSON(arr)
            
            XCTAssertThrowsError(try json[.foo].intValue()) {
                if case .invalidType(let key, let type)? = $0 as? JSONError {
                    XCTAssertEqual(key, "")
                    XCTAssertTrue(type == JSONKeyedContainer.self)
                } else {
                    XCTFail()
                }
            }
            
            XCTAssertThrowsError(try json[0].intValue()) {
                if case .invalidType(let key, let type)? = $0 as? JSONError {
                    XCTAssertEqual(key, "\\0")
                    XCTAssertTrue(type == Int.self)
                } else {
                    XCTFail()
                }
            }
            
            XCTAssertThrowsError(try json[0][.baz].intValue()) {
                if case .keyNotFound(let key)? = $0 as? JSONError {
                    XCTAssertEqual(key, "\\0.baz")
                } else {
                    XCTFail()
                }
            }

        }
    }
    
}


