//
//  ObjCDynamicPropertySynthesizingTests.swift
//  ObjCDeepDynamic
//
//  Created on 28/12/2018.
//

import XCTest
import Foundation
import ObjCDeepDynamic

class ObjCDynamicPropertySynthesizingSwiftTests: XCTestCase {
    var dynamicObject: ObjCDynamicPropertySynthesizingTestObject!
    
    override func setUp() {
        dynamicObject = ObjCDynamicPropertySynthesizingTestObject()
    }
    
    override func tearDown() {
        dynamicObject = nil
    }
    
    func testKVCAccessors() {
        let string: NSString = "sample string"
        dynamicObject.object = string
        XCTAssert((dynamicObject.value(forKey: "object") as AnyObject?) === string)
        
        // Integer value like 6 would be stored as tagged pointer.
        // Reference equity checking works here.
        dynamicObject.intValue = 6
        XCTAssert((dynamicObject.value(forKey: "intValue") as AnyObject?) === 6 as AnyObject)
    }
    
    func testObjectAccessors() {
        let string: NSString = "sample string"
        XCTAssert(dynamicObject.object === nil)
        dynamicObject.object = string
        XCTAssert(dynamicObject.object === string)
        dynamicObject.object = nil
        XCTAssert(dynamicObject.object === nil)
    }
    
    func testWeakObjectAccessors() {
        autoreleasepool {
            var string: NSString? = "sample string"
            XCTAssert(dynamicObject.objectWeak === nil)
            dynamicObject.objectWeak = string
            XCTAssert(dynamicObject.objectWeak === string)
            string = nil
        }
        
        XCTAssert(dynamicObject.objectWeak === nil)
    }
    
    func testIntegerAccessors() {
        XCTAssertEqual(dynamicObject.intValue, 0)
        XCTAssertEqual(dynamicObject.int8Value, 0)
        XCTAssertEqual(dynamicObject.int16Value, 0)
        XCTAssertEqual(dynamicObject.int32Value, 0)
        XCTAssertEqual(dynamicObject.int64Value, 0)
        XCTAssertEqual(dynamicObject.uintValue, 0)
        XCTAssertEqual(dynamicObject.uint8Value, 0)
        XCTAssertEqual(dynamicObject.uint16Value, 0)
        XCTAssertEqual(dynamicObject.uint32Value, 0)
        XCTAssertEqual(dynamicObject.uint64Value, 0)
        
        dynamicObject.intValue = 1
        dynamicObject.int8Value = 2
        dynamicObject.int16Value = 3
        dynamicObject.int32Value = 4
        dynamicObject.int64Value = 5
        dynamicObject.uintValue = 6
        dynamicObject.uint8Value = 7
        dynamicObject.uint16Value = 8
        dynamicObject.uint32Value = 9
        dynamicObject.uint64Value = 10
        
        XCTAssertEqual(dynamicObject.intValue, 1)
        XCTAssertEqual(dynamicObject.int8Value, 2)
        XCTAssertEqual(dynamicObject.int16Value, 3)
        XCTAssertEqual(dynamicObject.int32Value, 4)
        XCTAssertEqual(dynamicObject.int64Value, 5)
        XCTAssertEqual(dynamicObject.uintValue, 6)
        XCTAssertEqual(dynamicObject.uint8Value, 7)
        XCTAssertEqual(dynamicObject.uint16Value, 8)
        XCTAssertEqual(dynamicObject.uint32Value, 9)
        XCTAssertEqual(dynamicObject.uint64Value, 10)
    }
    
    func testFloatingPointAccessors() {
        XCTAssertEqual(dynamicObject.floatValue, 0)
        XCTAssertEqual(dynamicObject.float32Value, 0)
        XCTAssertEqual(dynamicObject.float64Value, 0)
        XCTAssertEqual(dynamicObject.doubleValue, 0)
        #if TARGET_OS_IOS
        XCTAssertEqual(dynamicObject.float80Value, 0)
        #endif
        
        dynamicObject.floatValue = 1
        dynamicObject.float32Value = 2
        dynamicObject.float64Value = 3
        dynamicObject.doubleValue = 4
        #if TARGET_OS_IOS
        dynamicObject.float80Value = 5
        #endif
        
        XCTAssertEqual(dynamicObject.floatValue, 1)
        XCTAssertEqual(dynamicObject.float32Value, 2)
        XCTAssertEqual(dynamicObject.float64Value, 3)
        XCTAssertEqual(dynamicObject.doubleValue, 4)
        #if TARGET_OS_IOS
        XCTAssertEqual(dynamicObject.float80Value, 5)
        #endif
    }
}
