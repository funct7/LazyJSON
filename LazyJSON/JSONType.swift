//
//  JSONType.swift
//  LazyJSON
//
//  Created by Joshua Park on 01/10/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import Foundation

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
