//
//  ObjCDynamicPropertySynthesizingTestObject.swift
//  ObjCDeepDynamic
//
//  Created on 28/12/2018.
//

import Foundation
import ObjCDeepDynamic

@objc
class ObjCDynamicPropertySynthesizingTestObject: NSObject, ObjCDynamicPropertySynthesizing {
    @NSManaged var object: AnyObject?
    
    @NSManaged weak var objectWeak: AnyObject?
    
    @NSManaged var intValue: Int
    
    @NSManaged var int8Value: Int8
    
    @NSManaged var int16Value: Int16
    
    @NSManaged var int32Value: Int32
    
    @NSManaged var int64Value: Int64
    
    @NSManaged var uintValue: UInt
    
    @NSManaged var uint8Value: UInt8
    
    @NSManaged var uint16Value: UInt16
    
    @NSManaged var uint32Value: UInt32
    
    @NSManaged var uint64Value: UInt64
    
    @NSManaged var floatValue: Float
    
    @NSManaged var float32Value: Float32
    
    @NSManaged var float64Value: Float64
    
    #if arch(x86_64) || arch(i386)
    @NSManaged var float80Value: Float80
    #endif
    
    @NSManaged var doubleValue: Double
    
    @NSManaged var boolValue: Bool
    
    @NSManaged var rangeValue: NSRange
    
    var _storage: [String : Any] = [:]
    
    func setPrimitiveValue(_ primitiveValue: Any?, forKey key: String) {
        _storage[key] = primitiveValue
    }
    
    func primitiveValue(forKey key: String) -> Any? {
        return _storage[key]
    }
}
