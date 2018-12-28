//
//  ObjCDynamicCodedTests.swift
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

import XCTest
import Foundation
import ObjCDeepDynamic

import CoreGraphics
#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
#endif

#if os(iOS) || os(OSX) || os(tvOS)
    import AVFoundation
#endif

class ObjCDynamicCodedTests: XCTestCase {
    func testIntegerAccessor() {
        let anEnumCase: ArchivableEnum = .integerAccessor(
            1,
            9,
            8,
            4,
            1,
            9,
            8,
            4,
            false
        )
        
        let anObject = ArchivableObject(anEnumCase)
        
        var unarchivedArbitraryObjectOrNil: Any?
        
        if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let archivedArbitraryObjectData = try! NSKeyedArchiver.archivedData(
                withRootObject: anObject,
                requiringSecureCoding: false
            )
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        } else {
            let archivedArbitraryObjectData = NSKeyedArchiver
                .archivedData(withRootObject: anObject)
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        }
        
        guard let unarchivedArbitraryObject = unarchivedArbitraryObjectOrNil
            as? ArchivableObject else
        {
            XCTFail()
            return
        }
        
        switch (anEnumCase, unarchivedArbitraryObject.archivableEnum) {
        case let (
            .integerAccessor(
                int8Original,
                int16Original,
                int32Original,
                int64Original,
                uint8Original,
                uint16Original,
                uint32Original,
                uint64Original,
                booleanOriginal
            ),
            .integerAccessor(
                int8Unarchived,
                int16Unarchived,
                int32Unarchived,
                int64Unarchived,
                uint8Unarchived,
                uint16Unarchived,
                uint32Unarchived,
                uint64Unarchived,
                booleanUnarchived
            )
            ):
            
            XCTAssert(int8Original == int8Unarchived, "\(int8Unarchived)")
            XCTAssert(int16Original == int16Unarchived, "\(int16Unarchived)")
            XCTAssert(int32Original == int32Unarchived, "\(int32Unarchived)")
            XCTAssert(int64Original == int64Unarchived, "\(int64Unarchived)")
            XCTAssert(uint8Original == uint8Unarchived, "\(uint8Unarchived)")
            XCTAssert(uint16Original == uint16Unarchived, "\(uint16Unarchived)")
            XCTAssert(uint32Original == uint32Unarchived, "\(uint32Unarchived)")
            XCTAssert(uint64Original == uint64Unarchived, "\(uint64Unarchived)")
            XCTAssert(booleanOriginal == booleanUnarchived, "\(booleanUnarchived)")
            
            break
        default:
            XCTFail()
        }
    }
    
    func testObjectAccessor() {
        let anEnumCase: ArchivableEnum = .objectAccessor(
            "String as object to test" as AnyObject
        )
        
        let anObject = ArchivableObject(anEnumCase)
        
        var unarchivedArbitraryObjectOrNil: Any?
        
        if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let archivedArbitraryObjectData = try! NSKeyedArchiver.archivedData(
                withRootObject: anObject,
                requiringSecureCoding: false
            )
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        } else {
            let archivedArbitraryObjectData = NSKeyedArchiver
                .archivedData(withRootObject: anObject)
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        }
        
        guard let unarchivedArbitraryObject = unarchivedArbitraryObjectOrNil
            as? ArchivableObject else
        {
            XCTFail()
            return
        }
        
        switch (anEnumCase, unarchivedArbitraryObject.archivableEnum) {
        case let (
            .objectAccessor(
                objectOriginal as String
            ),
            .objectAccessor(
                objectUnarchived as String
            )
            ):
            
            XCTAssert(objectOriginal == objectUnarchived)
            
            break
        default:
            XCTFail()
        }
    }
    
    func testSelectorAccessor() {
        let anEnumCase: ArchivableEnum = .selectorAccessor(
            NSSelectorFromString("testSelectorAccessor")
        )
        
        let anObject = ArchivableObject(anEnumCase)
        
        var unarchivedArbitraryObjectOrNil: Any?
        
        if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let archivedArbitraryObjectData = try! NSKeyedArchiver.archivedData(
                withRootObject: anObject,
                requiringSecureCoding: false
            )
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        } else {
            let archivedArbitraryObjectData = NSKeyedArchiver
                .archivedData(withRootObject: anObject)
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        }
        
        guard let unarchivedArbitraryObject = unarchivedArbitraryObjectOrNil
            as? ArchivableObject else
        {
            XCTFail()
            return
        }
        
        switch (anEnumCase, unarchivedArbitraryObject.archivableEnum) {
        case let (
            .selectorAccessor(
                selectorOriginal
            ),
            .selectorAccessor(
                selectorUnarchived
            )
            ):
            
            XCTAssert(selectorOriginal == selectorUnarchived)
            
            break
        default:
            XCTFail()
        }
    }
    
    func testFloatingPointAccessor() {
        let anEnumCase: ArchivableEnum = .floatingPointAccessor(
            3.14, 1.7
        )
        
        let anObject = ArchivableObject(anEnumCase)
        
        var unarchivedArbitraryObjectOrNil: Any?
        
        if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let archivedArbitraryObjectData = try! NSKeyedArchiver.archivedData(
                withRootObject: anObject,
                requiringSecureCoding: false
            )
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        } else {
            let archivedArbitraryObjectData = NSKeyedArchiver
                .archivedData(withRootObject: anObject)
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        }
        
        guard let unarchivedArbitraryObject = unarchivedArbitraryObjectOrNil
            as? ArchivableObject else
        {
            XCTFail()
            return
        }
        
        switch (anEnumCase, unarchivedArbitraryObject.archivableEnum) {
        case let (
            .floatingPointAccessor(
                doubleOriginal, floatOriginal
            ),
            .floatingPointAccessor(
                doubleUnarchived, floatUnarchived
            )
            ):
            
            XCTAssert(doubleOriginal == doubleUnarchived, "original \(doubleOriginal), unarchived: \(doubleUnarchived)")
            XCTAssert(floatOriginal == floatUnarchived, "original \(floatOriginal), unarchived: \(floatUnarchived)")
            
            break
        default:
            XCTFail()
        }
    }
    
    
    
    func testFoundationAccessor() {
        let anEnumCase: ArchivableEnum = .foundationAccessor(
            NSRange(location: 19, length: 84)
        )
        
        let anObject = ArchivableObject(anEnumCase)
        
        var unarchivedArbitraryObjectOrNil: Any?
        
        if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let archivedArbitraryObjectData = try! NSKeyedArchiver.archivedData(
                withRootObject: anObject,
                requiringSecureCoding: false
            )
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        } else {
            let archivedArbitraryObjectData = NSKeyedArchiver
                .archivedData(withRootObject: anObject)
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        }
        
        guard let unarchivedArbitraryObject = unarchivedArbitraryObjectOrNil
            as? ArchivableObject else
        {
            XCTFail()
            return
        }
        
        switch (anEnumCase, unarchivedArbitraryObject.archivableEnum) {
        case let (
            .foundationAccessor(rangeOriginal),
            .foundationAccessor(rangeUnarchived)
            ):
            
            XCTAssert(rangeOriginal == rangeUnarchived)
            
            break
        default:
            XCTFail()
        }
    }
    
    func testCGAccessors() {
        let anEnumCase: ArchivableEnum = .cgAccessor(
            CGPoint(x: 1, y: 1),
            CGVector(dx: 2, dy: 2),
            CGSize(width: 3, height: 3),
            CGRect(x: 4, y: 4, width: 4, height: 4),
            CGAffineTransform.identity
        )
        
        let anObject = ArchivableObject(anEnumCase)
        
        var unarchivedArbitraryObjectOrNil: Any?
        
        if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let archivedArbitraryObjectData = try! NSKeyedArchiver.archivedData(
                withRootObject: anObject,
                requiringSecureCoding: false
            )
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        } else {
            let archivedArbitraryObjectData = NSKeyedArchiver
                .archivedData(withRootObject: anObject)
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        }
        
        guard let unarchivedArbitraryObject = unarchivedArbitraryObjectOrNil
            as? ArchivableObject else
        {
            XCTFail()
            return
        }
        
        switch (anEnumCase, unarchivedArbitraryObject.archivableEnum) {
        case let (
            .cgAccessor(
                pointOriginal, vectorOriginal, sizeOriginal, rectOriginal, trasnformOriginal
            ),
            .cgAccessor(
                pointUnarchived, vectorUnarchived, sizeUnarchived, rectUnarchived, trasnformUnarchived
            )
            ):
            
            XCTAssert(pointOriginal == pointUnarchived)
            XCTAssert(vectorOriginal == vectorUnarchived, "original: \(vectorOriginal), vector: \(vectorUnarchived)")
            XCTAssert(sizeOriginal == sizeUnarchived)
            XCTAssert(rectOriginal == rectUnarchived)
            XCTAssert(trasnformOriginal == trasnformUnarchived, "original: \(trasnformOriginal), vector: \(trasnformUnarchived)")
            
            break
        default:
            XCTFail()
        }
    }
    
    #if os(iOS) || os(watchOS) || os(tvOS)
    func testUIKitAccessors() {
        let anEnumCase: ArchivableEnum = .uiKitAccessor(
            UIOffset(horizontal: 1, vertical: 1),
            UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        )
        
        let anObject = ArchivableObject(anEnumCase)
        
        var unarchivedArbitraryObjectOrNil: Any?
        
        if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let archivedArbitraryObjectData = try! NSKeyedArchiver.archivedData(
                withRootObject: anObject,
                requiringSecureCoding: false
            )
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        } else {
            let archivedArbitraryObjectData = NSKeyedArchiver
                .archivedData(withRootObject: anObject)
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        }
        
        guard let unarchivedArbitraryObject = unarchivedArbitraryObjectOrNil
            as? ArchivableObject else
        {
            XCTFail()
            return
        }
        
        switch (anEnumCase, unarchivedArbitraryObject.archivableEnum) {
        case let (
            .uiKitAccessor(offsetOriginal, edgeInsetsOriginal),
            .uiKitAccessor(offsetUnarchived, edgeInsetsUnarchived)
            ):
            
            XCTAssert(offsetOriginal == offsetUnarchived)
            XCTAssert(edgeInsetsOriginal == edgeInsetsUnarchived)
            break
        default:
            XCTFail()
        }
    }
    #endif
    
    
    #if os(iOS) || os(OSX) || os(tvOS)
    func testQuartzCoreAccessors() {
        let anEnumCase: ArchivableEnum = .quartzCoreAccessor(
            CATransform3DIdentity
        )
        
        let anObject = ArchivableObject(anEnumCase)
        
        var unarchivedArbitraryObjectOrNil: Any?
        
        if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let archivedArbitraryObjectData = try! NSKeyedArchiver.archivedData(
                withRootObject: anObject,
                requiringSecureCoding: false
            )
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        } else {
            let archivedArbitraryObjectData = NSKeyedArchiver
                .archivedData(withRootObject: anObject)
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        }
        
        guard let unarchivedArbitraryObject = unarchivedArbitraryObjectOrNil
            as? ArchivableObject else
        {
            XCTFail()
            return
        }
        
        switch (anEnumCase, unarchivedArbitraryObject.archivableEnum) {
        case let (
            .quartzCoreAccessor(transform3DOriginal),
            .quartzCoreAccessor(transform3DUnarchived)
            ):
            
            XCTAssert(CATransform3DEqualToTransform(transform3DOriginal, transform3DUnarchived))
            break
        default:
            XCTFail()
        }
    }
    #endif
    
    
    #if os(iOS) || os(OSX) || os(tvOS)
    func testAVFoundationAccessors() {
        let anEnumCase: ArchivableEnum = .avFoundationAccessor(
            CMTime(seconds: 1, preferredTimescale: 1),
            CMTimeRange(
                start: CMTime(seconds: 1, preferredTimescale: 10),
                duration: CMTime(seconds: 10, preferredTimescale: 10)
            ),
            CMTimeMapping(
                source: CMTimeRange(
                    start: CMTime(seconds: 0, preferredTimescale: 10),
                    duration: CMTime(seconds: 10, preferredTimescale: 10)
                ),
                target: CMTimeRange(
                    start: CMTime(seconds: 0, preferredTimescale: 100),
                    duration: CMTime(seconds: 1, preferredTimescale: 100)
                )
            )
        )
        
        let anObject = ArchivableObject(anEnumCase)
        
        var unarchivedArbitraryObjectOrNil: Any?
        
        if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let archivedArbitraryObjectData = try! NSKeyedArchiver.archivedData(
                withRootObject: anObject,
                requiringSecureCoding: false
            )
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        } else {
            let archivedArbitraryObjectData = NSKeyedArchiver
                .archivedData(withRootObject: anObject)
            
            unarchivedArbitraryObjectOrNil = try! NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(archivedArbitraryObjectData)
        }
        
        guard let unarchivedArbitraryObject = unarchivedArbitraryObjectOrNil
            as? ArchivableObject else
        {
            XCTFail()
            return
        }
        
        switch (anEnumCase, unarchivedArbitraryObject.archivableEnum) {
        case let (
            .avFoundationAccessor(
                timeOriginal,
                timeRangeOriginal,
                timeMappingOriginal
            ),
            .avFoundationAccessor(
                timeUnarchived,
                timeRangeUnarchived,
                timeMappingUnarchived)
            ):
            
            XCTAssert(timeOriginal == timeUnarchived)
            XCTAssert(timeRangeOriginal == timeRangeUnarchived)
            XCTAssert(
                timeMappingOriginal.source == timeMappingUnarchived.source
                    && timeMappingOriginal.target == timeMappingUnarchived.target
            )
            break
        default:
            XCTFail()
        }
    }
    #endif

}
