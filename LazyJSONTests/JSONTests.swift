//
//  JSONTests.swift
//  ValidJSONTests
//
//  Created by Joshua Park on 28/09/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import XCTest
@testable import LazyJSON

fileprivate extension Optional.Key {
    
    static var foo: JSON.Key { return JSON.Key("foo") }
    
    static var bar: JSON.Key { return JSON.Key("bar") }
    
    static var baz: JSON.Key { return JSON.Key("baz") }
    
}

class JSONTests: XCTestCase {
    
    func testTopLevelDictionary() {
        var dic = [String : Any]()
        
        do {
            let json = JSON(dic)
            
            XCTAssertNotNil(json)
            
            XCTAssertNil(json.number)
            XCTAssertNil(json.string)
            XCTAssertNil(json.array)
            XCTAssertNotNil(json.json)
            XCTAssertEqual(json.json?.isEmpty, true)
        }
        
        dic["foo"] = 10
        
        do {
            let json = JSON(dic)
            
            XCTAssertNotNil(json.json)
            
            XCTAssertNotNil(json[.foo])
            XCTAssertEqual(json[.foo].number, 10)
            XCTAssertEqual(json[.foo].int, 10)
            XCTAssertNil(json[.foo].double)
            XCTAssertNil(json[.foo].bool)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
            XCTAssertNil(json[0])
        }
        
        dic["foo"] = 10.0
        
        do {
            let json = JSON(dic)
            
            XCTAssertNotNil(json.json)
            
            XCTAssertNotNil(json[.foo])
            XCTAssertEqual(json[.foo].number, 10.0)
            XCTAssertNil(json[.foo].int)
            XCTAssertEqual(json[.foo].double, 10.0)
            XCTAssertNil(json[.foo].bool)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
        }
        
        dic["foo"] = NSNumber(value: 42.0)
        
        do {
            let json = JSON(dic)
            
            XCTAssertNotNil(json.json)
            
            XCTAssertNotNil(json[.foo])
            XCTAssertEqual(json[.foo].number, 42.0)
            XCTAssertEqual(json[.foo].int, 42)
            XCTAssertEqual(json[.foo].double, 42.0)
            XCTAssertNil(json[.foo].bool)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
        }
        
        dic["foo"] = true
        
        do {
            let json = JSON(dic)
            
            XCTAssertNotNil(json.json)
            
            XCTAssertNotNil(json[.foo])
            XCTAssertEqual(json[.foo].number, 1)
            XCTAssertNil(json[.foo].int)
            XCTAssertNil(json[.foo].double)
            XCTAssertEqual(json[.foo].bool, true)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
        }
        
        dic["foo"] = "bar"
        
        do {
            let json = JSON(dic)
            
            XCTAssertNotNil(json.json)
            
            XCTAssertNotNil(json[.foo])
            XCTAssertNil(json[.foo].number)
            XCTAssertEqual(json[.foo].string, "bar")
            XCTAssertNil(json[.foo].array)
        }
        
        dic["foo"] = ["bar"]
        
        do {
            let json = JSON(dic)
            
            XCTAssertNotNil(json.json)
            
            XCTAssertNotNil(json[.foo])
            XCTAssertNil(json[.foo].number)
            XCTAssertNil(json[.foo].string)
            XCTAssertNotNil(json[.foo].array)
            XCTAssertEqual(json[.foo].array?.isEmpty, false)
            
            XCTAssertNotNil(json[.foo][0])
            XCTAssertEqual(json[.foo][0].string, "bar")
            
            XCTAssertNil(json[.foo][1])
            XCTAssertNil(json[.foo][1].string)
        }
        
        dic["foo"] = ["bar": "baz"]
        
        do {
            let json = JSON(dic)
            
            XCTAssertNotNil(json.json)
            
            XCTAssertNotNil(json[.foo].json)
            XCTAssertNil(json[.foo].number)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
            
            XCTAssertNotNil(json[.foo][.bar])
            XCTAssertNotNil(json[.foo][.bar], "baz")
            XCTAssertEqual(json[.foo][.bar].string, "baz")
            XCTAssertEqual(json[.foo][.bar].string, "baz")
        }
        
        dic["foo"] = ["bar": ["baz" : 42]]
        
        do {
            let json = JSON(dic)
            
            XCTAssertNotNil(json.json)
            
            XCTAssertNotNil(json[.foo].json)
            XCTAssertNil(json[.foo].number)
            XCTAssertNil(json[.foo].string)
            XCTAssertNil(json[.foo].array)
            
            XCTAssertNotNil(json[.foo][.bar])
            XCTAssertNil(json[.foo][.bar].number)
            XCTAssertNil(json[.foo][.bar].string)
            XCTAssertNil(json[.foo][.bar].array)
            XCTAssertNotNil(json[.foo][.bar].json)
            
            XCTAssertNil(json[.foo][.foo].json)
            
            XCTAssertEqual(json[.foo][.bar].json?.count, 1)
            
            XCTAssertNotNil(json[.foo][.bar][.baz])
            XCTAssertEqual(json[.foo][.bar][.baz].number, 42)
            XCTAssertEqual(json[.foo][.bar][.baz].int, 42)
            XCTAssertNil(json[.foo][.bar][.baz].double)
            XCTAssertNil(json[.foo][.bar][.baz].bool)
            XCTAssertNil(json[.foo][.bar][.baz].string)
            XCTAssertNil(json[.foo][.bar][.baz].array)
            XCTAssertNil(json[.foo][.bar][.baz].json)
        }
        
        dic["foo"] = [["bar": 10],
                      ["baz" : 42]]
        
        do {
            let json = JSON(dic)
            
            XCTAssertNotNil(json.json)
            
            XCTAssertNotNil(json[.foo])
            XCTAssertNil(json[.foo].json)
            XCTAssertNil(json[.foo].number)
            XCTAssertNil(json[.foo].string)
            XCTAssertNotNil(json[.foo].array)
            XCTAssertEqual(json[.foo].array?.count, 2)
            XCTAssertNil(json[.foo][.bar])
            
            XCTAssertNil(json[.foo][0].number)
            XCTAssertNil(json[.foo][0].string)
            XCTAssertNil(json[.foo][0].array)
            XCTAssertNotNil(json[.foo][0].json)
            XCTAssertEqual(json[.foo][0].json?.count, 1)
            
            XCTAssertEqual(json[.foo][0][.bar].number, 10)
            XCTAssertNil(json[.foo][0][.bar].string)
            XCTAssertNil(json[.foo][0][.bar].array)
            XCTAssertNil(json[.foo][0][.bar].json)
            
            XCTAssertNil(json[.foo][1].number)
            XCTAssertNil(json[.foo][1].string)
            XCTAssertNil(json[.foo][1].array)
            XCTAssertNotNil(json[.foo][1].json)
            XCTAssertEqual(json[.foo][1].json?.count, 1)
            
            XCTAssertEqual(json[.foo][1][.baz].number, 42)
            XCTAssertNil(json[.foo][1][.baz].string)
            XCTAssertNil(json[.foo][1][.baz].array)
            XCTAssertNil(json[.foo][1][.baz].json)
            XCTAssertNil(json[.foo][2])
        }
    }
    
    func testTopLevelArray() {
        var array = [Any]()
        
        do {
            let json = JSON(array)
            
            XCTAssertNotNil(json)
            
            XCTAssertNil(json.number)
            XCTAssertNil(json.string)
            XCTAssertNotNil(json.array)
            XCTAssertEqual(json.array?.isEmpty, true)
            XCTAssertNil(json.json)
        }
        
        array.append(10)
        
        do {
            let json = JSON(array)
            
            XCTAssertNotNil(json.array)
            
            XCTAssertNotNil(json[0])
            XCTAssertEqual(json[0].number, 10)
            XCTAssertEqual(json[0].int, 10)
            XCTAssertNil(json[0].double)
            XCTAssertNil(json[0].bool)
            XCTAssertNil(json[0].string)
            XCTAssertNil(json[0].array)
            XCTAssertNil(json[.foo])
        }
        
//        array[0] = 10.0
//
//        do {
//            let json = JSON(array)
//
//            XCTAssertNotNil(json.json)
//
//            XCTAssertNotNil(json[.foo])
//            XCTAssertEqual(json[.foo].number, 10.0)
//            XCTAssertNil(json[.foo].int)
//            XCTAssertEqual(json[.foo].double, 10.0)
//            XCTAssertNil(json[.foo].bool)
//            XCTAssertNil(json[.foo].string)
//            XCTAssertNil(json[.foo].array)
//        }
//
//        array[0] = NSNumber(value: 42.0)
//
//        do {
//            let json = JSON(array)
//
//            XCTAssertNotNil(json.json)
//
//            XCTAssertNotNil(json[.foo])
//            XCTAssertEqual(json[.foo].number, 42.0)
//            XCTAssertEqual(json[.foo].int, 42)
//            XCTAssertEqual(json[.foo].double, 42.0)
//            XCTAssertNil(json[.foo].bool)
//            XCTAssertNil(json[.foo].string)
//            XCTAssertNil(json[.foo].array)
//        }
//
//        array["foo"] = true
//
//        do {
//            let json = JSON(array)
//
//            XCTAssertNotNil(json.json)
//
//            XCTAssertNotNil(json[.foo])
//            XCTAssertEqual(json[.foo].number, 1)
//            XCTAssertNil(json[.foo].int)
//            XCTAssertNil(json[.foo].double)
//            XCTAssertEqual(json[.foo].bool, true)
//            XCTAssertNil(json[.foo].string)
//            XCTAssertNil(json[.foo].array)
//        }
//
//        array["foo"] = "bar"
//
//        do {
//            let json = JSON(array)
//
//            XCTAssertNotNil(json.json)
//
//            XCTAssertNotNil(json[.foo])
//            XCTAssertNil(json[.foo].number)
//            XCTAssertEqual(json[.foo].string, "bar")
//            XCTAssertNil(json[.foo].array)
//        }
//
//        array["foo"] = ["bar"]
//
//        do {
//            let json = JSON(array)
//
//            XCTAssertNotNil(json.json)
//
//            XCTAssertNotNil(json[.foo])
//            XCTAssertNil(json[.foo].number)
//            XCTAssertNil(json[.foo].string)
//            XCTAssertNotNil(json[.foo].array)
//            XCTAssertEqual(json[.foo].array?.isEmpty, false)
//
//            XCTAssertNotNil(json[.foo][0])
//            XCTAssertEqual(json[.foo][0].string, "bar")
//
//            XCTAssertNil(json[.foo][1])
//            XCTAssertNil(json[.foo][1].string)
//        }
//
//        array["foo"] = ["bar": "baz"]
//
//        do {
//            let json = JSON(array)
//
//            XCTAssertNotNil(json.json)
//
//            XCTAssertNotNil(json[.foo].json)
//            XCTAssertNil(json[.foo].number)
//            XCTAssertNil(json[.foo].string)
//            XCTAssertNil(json[.foo].array)
//
//            XCTAssertNotNil(json[.foo][.bar])
//            XCTAssertNotNil(json[.foo][.bar], "baz")
//            XCTAssertEqual(json[.foo][.bar].string, "baz")
//            XCTAssertEqual(json[.foo][.bar].string, "baz")
//        }
//
//        array["foo"] = ["bar": ["baz" : 42]]
//
//        do {
//            let json = JSON(array)
//
//            XCTAssertNotNil(json.json)
//
//            XCTAssertNotNil(json[.foo].json)
//            XCTAssertNil(json[.foo].number)
//            XCTAssertNil(json[.foo].string)
//            XCTAssertNil(json[.foo].array)
//
//            XCTAssertNotNil(json[.foo][.bar])
//            XCTAssertNil(json[.foo][.bar].number)
//            XCTAssertNil(json[.foo][.bar].string)
//            XCTAssertNil(json[.foo][.bar].array)
//            XCTAssertNotNil(json[.foo][.bar].json)
//
//            XCTAssertNil(json[.foo][.foo].json)
//
//            XCTAssertEqual(json[.foo][.bar].json?.count, 1)
//
//            XCTAssertNotNil(json[.foo][.bar][.baz])
//            XCTAssertEqual(json[.foo][.bar][.baz].number, 42)
//            XCTAssertEqual(json[.foo][.bar][.baz].int, 42)
//            XCTAssertNil(json[.foo][.bar][.baz].double)
//            XCTAssertNil(json[.foo][.bar][.baz].bool)
//            XCTAssertNil(json[.foo][.bar][.baz].string)
//            XCTAssertNil(json[.foo][.bar][.baz].array)
//            XCTAssertNil(json[.foo][.bar][.baz].json)
//        }
//
//        array["foo"] = [["bar": 10],
//                      ["baz" : 42]]
//
//        do {
//            let json = JSON(array)
//
//            XCTAssertNotNil(json.json)
//
//            XCTAssertNotNil(json[.foo])
//            XCTAssertNil(json[.foo].json)
//            XCTAssertNil(json[.foo].number)
//            XCTAssertNil(json[.foo].string)
//            XCTAssertNotNil(json[.foo].array)
//            XCTAssertEqual(json[.foo].array?.count, 2)
//            XCTAssertNil(json[.foo][.bar])
//
//            XCTAssertNil(json[.foo][0].number)
//            XCTAssertNil(json[.foo][0].string)
//            XCTAssertNil(json[.foo][0].array)
//            XCTAssertNotNil(json[.foo][0].json)
//            XCTAssertEqual(json[.foo][0].json?.count, 1)
//
//            XCTAssertEqual(json[.foo][0][.bar].number, 10)
//            XCTAssertNil(json[.foo][0][.bar].string)
//            XCTAssertNil(json[.foo][0][.bar].array)
//            XCTAssertNil(json[.foo][0][.bar].json)
//
//            XCTAssertNil(json[.foo][1].number)
//            XCTAssertNil(json[.foo][1].string)
//            XCTAssertNil(json[.foo][1].array)
//            XCTAssertNotNil(json[.foo][1].json)
//            XCTAssertEqual(json[.foo][1].json?.count, 1)
//
//            XCTAssertEqual(json[.foo][1][.baz].number, 42)
//            XCTAssertNil(json[.foo][1][.baz].string)
//            XCTAssertNil(json[.foo][1][.baz].array)
//            XCTAssertNil(json[.foo][1][.baz].json)
//            XCTAssertNil(json[.foo][2])
//        }
    }

    
}
