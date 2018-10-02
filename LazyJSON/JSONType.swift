//
//  JSONType.swift
//  LazyJSON
//
//  Created by Joshua Park on 01/10/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import Foundation

public protocol JSONType { }

public protocol JSONElementType: JSONType { }

public protocol JSONContainerType: JSONType { }

public typealias JSONIndexedContainer = [JSONType]

public typealias JSONKeyedContainer = [String : JSONType]

extension Dictionary : JSONType, JSONContainerType where Key == String, Value == JSONType { }

extension Array : JSONType, JSONContainerType where Element == JSONType { }

extension NSNumber : JSONType, JSONElementType { }

extension NSString : JSONType, JSONElementType { }

extension Int : JSONType, JSONElementType { }

extension Double : JSONType, JSONElementType { }

extension Bool : JSONType, JSONElementType { }

extension String : JSONType, JSONElementType { }
