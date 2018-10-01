//
//  JSONTests.swift
//  ValidJSONTests
//
//  Created by Joshua Park on 28/09/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import XCTest
@testable import LazyJSON

fileprivate extension JSON.Key {
    
    static var foo: JSON.Key { return JSON.Key(rawValue: "foo")! }
    
    static var bar: JSON.Key { return JSON.Key(rawValue: "bar")! }
    
}

class JSONTests: XCTestCase {
    
    func testType() {
        var dic = [String : JSONType]()
        
        do {
            let json = JSON(object: dic)
            
            XCTAssertNil(json.number)
            XCTAssertNil(json.string)
            XCTAssertNil(json.array)
            XCTAssertNotNil(json.json)
            XCTAssertEqual(json.json?.isEmpty, true)
        }
        
        dic["foo"] = 10
        
        do {
            let json = JSON(object: dic)
            
            XCTAssertEqual(json[.foo].number, 10)
            XCTAssertEqual(json[.foo].int, 10)
            XCTAssertNil(json[.foo].double)
            XCTAssertNil(json[.foo].bool)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
            XCTAssertNotNil(json.json)
        }
        
        dic["foo"] = 10.0
        
        do {
            let json = JSON(object: dic)
            
            XCTAssertEqual(json[.foo].number, 10.0)
            XCTAssertNil(json[.foo].int)
            XCTAssertEqual(json[.foo].double, 10.0)
            XCTAssertNil(json[.foo].bool)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
            XCTAssertNotNil(json.json)
        }
        
        dic["foo"] = NSNumber(value: 42.0)
        
        do {
            let json = JSON(object: dic)
            
            XCTAssertEqual(json[.foo].number, 42.0)
            XCTAssertEqual(json[.foo].int, 42)
            XCTAssertEqual(json[.foo].double, 42.0)
            XCTAssertNil(json[.foo].bool)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
            XCTAssertNotNil(json.json)
        }
        
        dic["foo"] = true
        
        do {
            let json = JSON(object: dic)
            
            XCTAssertEqual(json[.foo].number, 1)
            XCTAssertNil(json[.foo].int)
            XCTAssertNil(json[.foo].double)
            XCTAssertEqual(json[.foo].bool, true)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
            XCTAssertNotNil(json.json)
        }
        
        dic["foo"] = "bar"
        
        do {
            let json = JSON(object: dic)
            
            XCTAssertNil(json[.foo].number)
            XCTAssertEqual(json[.foo].string, "bar")
            XCTAssertNil(json[.foo].array)
            XCTAssertNotNil(json.json)
        }
        
        dic["foo"] = ["bar"]
        
        do {
            let json = JSON(object: dic)
            
            XCTAssertNil(json[.foo].number)
            XCTAssertNil(json[.foo].string)
            XCTAssertNotNil(json[.foo].array)
            XCTAssertEqual(json[.foo].array?.isEmpty, false)
            // TODO: Fix this... array of JSONs?
            XCTAssertEqual(json[.foo].array?.first as? String, "bar")
            XCTAssertEqual(JSON(object: json[.foo].array)[0].string, "bar")
            XCTAssertNil(JSON(object: json[.foo].array)[1].string)
            XCTAssertNotNil(json.json)
        }
        
        dic["foo"] = ["bar": "baz"]
        
        do {
            let json = JSON(object: dic)
            
            XCTAssertNil(json[.foo].number)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
            XCTAssertNotNil(json.json)
            XCTAssertNotNil(json[.foo].json)
            XCTAssertNotNil(JSON(object: json[.foo].json)[.bar], "baz")
        }
    }
    
}
