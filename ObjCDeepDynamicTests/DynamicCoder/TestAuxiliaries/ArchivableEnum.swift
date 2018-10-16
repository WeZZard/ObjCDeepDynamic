//
//  ArchivableEnum.swift
//  ObjCDeepDynamic
//
//  Created on 16/10/2018.
//

import XCTest
import Foundation

import CoreGraphics

#if os(iOS) || os(watchOS) || os(tvOS)
import UIKit
#endif

#if os(iOS) || os(OSX) || os(tvOS)
import AVFoundation
#endif

@testable
import ObjCDeepDynamic


internal enum ArchivableEnum {
    case objectAccessor(AnyObject)
    case selectorAccessor(Selector)
    case integerAccessor(
        Int8,
        Int16,
        Int32,
        Int64,
        UInt8,
        UInt16,
        UInt32,
        UInt64,
        Bool
    )
    case floatingPointAccessor(Double, Float)
    
    case foundationAccessor(NSRange)
    
    case cgAccessor(CGPoint, CGVector, CGSize, CGRect, CGAffineTransform)
    
    #if os(iOS) || os(watchOS) || os(tvOS)
    case uiKitAccessor(UIOffset, UIEdgeInsets)
    #endif
    
    #if os(iOS) || os(OSX) || os(tvOS)
    case quartzCoreAccessor(CATransform3D)
    case avFoundationAccessor(CMTime, CMTimeRange, CMTimeMapping)
    #endif
}

extension ArchivableEnum: _ObjectiveCBridgeable {
    typealias _ObjectiveCType = ArchivableEnumObjCBridged
    
    func _bridgeToObjectiveC() -> _ObjectiveCType {
        if case let .objectAccessor(object) = self {
            let bridged = ArchivableEnumObjectAccessorObjCBridged()
            bridged.objectValue = object
            return bridged
        }
        
        if case let .selectorAccessor(selector) = self {
            let bridged = ArchivableEnumSelectorAccessorObjCBridged()
            bridged.selector = selector
            return bridged
        }
        
        if case let .integerAccessor(
            int8, int16, int32, int64, uint8, uint16, uint32, uint64, boolean)
            = self
        {
            let bridged = ArchivableEnumIntegerAccessorObjCBridged()
            bridged.Int8Value = int8
            bridged.Int16Value = int16
            bridged.Int32Value = int32
            bridged.Int64Value = int64
            bridged.UInt8Value = uint8
            bridged.UInt16Value = uint16
            bridged.UInt32Value = uint32
            bridged.UInt64Value = uint64
            bridged.BoolValue = boolean
            return bridged
        }
        
        if case let .floatingPointAccessor(double, float) = self {
            let bridged = ArchivableEnumFloatingPointAccessorObjCBridged()
            bridged.floatValue = float
            bridged.doubleValue = double
            return bridged
        }
        
        if case let .foundationAccessor(range) = self {
            let bridged = ArchivableEnumFoundationAccessorObjCBridged()
            bridged.rangeValue = range
            return bridged
        }
        
        if case let .cgAccessor(point, vector, size, rect, transform) = self {
            let bridged = ArchivableEnumCGAccessorObjCBridged()
            bridged.CGPointValue = point
            bridged.CGVectorValue = vector
            bridged.CGSizeValue = size
            bridged.CGRectValue = rect
            bridged.CGAffineTransformValue = transform
            return bridged
        }
        
        #if os(iOS) || os(watchOS) || os(tvOS)
        if case let .uiKitAccessor(offset, edgeInsets) = self {
            let bridged = ArchivableEnumUIKitAccessorObjCBridged()
            
            bridged.offset = offset
            bridged.edgeInsets = edgeInsets
            
            return bridged
        }
        #endif
        
        #if os(iOS) || os(OSX) || os(tvOS)
        if case let .quartzCoreAccessor(transform3D) = self {
            let bridged = ArchivableEnumQuartzCoreAccessorObjCBridged()
            
            bridged.CATransform3DValue = transform3D
            
            return bridged
        }
        
        if case let .avFoundationAccessor(time, timeRange, timeMapping)
            = self
        {
            let bridged = ArchivableEnumAVFoundationAccessorObjCBridged()
            
            bridged.CMTimeValue = time
            bridged.CMTimeRangeValue = timeRange
            bridged.CMTimeMappingValue = timeMapping
            
            return bridged
        }
        #endif
        
        fatalError("This function needs to be implemented!")
    }
    
    static func _forceBridgeFromObjectiveC(
        _ source: _ObjectiveCType,
        result: inout ArchivableEnum?
        )
    {
        if let selectorAccessor = source
            as? ArchivableEnumSelectorAccessorObjCBridged
        {
            result = .selectorAccessor(selectorAccessor.selector)
        }
        
        if let objectAccessor = source
            as? ArchivableEnumObjectAccessorObjCBridged
        {
            result = .objectAccessor(objectAccessor.objectValue)
        }
        
        if let integerAccessor = source
            as? ArchivableEnumIntegerAccessorObjCBridged
        {
            result = .integerAccessor(
                integerAccessor.Int8Value,
                integerAccessor.Int16Value,
                integerAccessor.Int32Value,
                integerAccessor.Int64Value,
                integerAccessor.UInt8Value,
                integerAccessor.UInt16Value,
                integerAccessor.UInt32Value,
                integerAccessor.UInt64Value,
                integerAccessor.BoolValue
            )
        }
        
        if let floatingPointAccessor = source
            as? ArchivableEnumFloatingPointAccessorObjCBridged
        {
            result = .floatingPointAccessor(
                floatingPointAccessor.doubleValue,
                floatingPointAccessor.floatValue
            )
        }
        
        if let rangeAccessor = source
            as? ArchivableEnumFoundationAccessorObjCBridged
        {
            result = .foundationAccessor(
                rangeAccessor.rangeValue
            )
        }
        
        if let CGAccessor = source as? ArchivableEnumCGAccessorObjCBridged {
            result = .cgAccessor(
                CGAccessor.CGPointValue,
                CGAccessor.CGVectorValue,
                CGAccessor.CGSizeValue,
                CGAccessor.CGRectValue,
                CGAccessor.CGAffineTransformValue
            )
        }
        
        #if os(iOS) || os(watchOS) || os(tvOS)
        if let UIKitAccessor = source
            as? ArchivableEnumUIKitAccessorObjCBridged
        {
            result = .uiKitAccessor(
                UIKitAccessor.offset,
                UIKitAccessor.edgeInsets
            )
        }
        #endif
        
        #if os(iOS) || os(OSX) || os(tvOS)
        if let QuartzCoreAccessor = source
            as? ArchivableEnumQuartzCoreAccessorObjCBridged
        {
            result = .quartzCoreAccessor(
                QuartzCoreAccessor.CATransform3DValue
            )
        }
        
        if let AVFoundationAccessor = source
            as? ArchivableEnumAVFoundationAccessorObjCBridged
        {
            result = .avFoundationAccessor(
                AVFoundationAccessor.CMTimeValue,
                AVFoundationAccessor.CMTimeRangeValue,
                AVFoundationAccessor.CMTimeMappingValue
            )
        }
        #endif
    }
    
    static func _conditionallyBridgeFromObjectiveC(
        _ source: _ObjectiveCType,
        result: inout ArchivableEnum?
        )
        -> Bool
    {
        _forceBridgeFromObjectiveC(source, result: &result)
        return result != nil
    }
    
    static func _unconditionallyBridgeFromObjectiveC(
        _ source: _ObjectiveCType?
        )
        -> ArchivableEnum
    {
        var result: ArchivableEnum?
        _forceBridgeFromObjectiveC(source!, result: &result)
        return result!
    }
}
