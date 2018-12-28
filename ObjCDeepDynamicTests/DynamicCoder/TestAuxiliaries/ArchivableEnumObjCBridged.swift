//
//  ArchivableEnumObjCBridged.swift
//  ObjCDeepDynamic
//
//  Created on 16/10/2018.
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


@objc
internal class ArchivableEnumObjCBridged: ObjCDynamicCoded {
    
}

@objc
internal final class ArchivableEnumObjectAccessorObjCBridged:
    ArchivableEnumObjCBridged
{
    @NSManaged
    var objectValue: AnyObject
}

@objc
internal final class ArchivableEnumIntegerAccessorObjCBridged:
    ArchivableEnumObjCBridged
{
    @NSManaged
    var Int8Value: Int8
    
    @NSManaged
    var Int16Value: Int16
    
    @NSManaged
    var Int32Value: Int32
    
    @NSManaged
    var Int64Value: Int64
    
    @NSManaged
    var UInt8Value: UInt8
    
    @NSManaged
    var UInt16Value: UInt16
    
    @NSManaged
    var UInt32Value: UInt32
    
    @NSManaged
    var UInt64Value: UInt64
    
    @NSManaged
    var BoolValue: Bool
}

@objc
internal final class ArchivableEnumSelectorAccessorObjCBridged:
    ArchivableEnumObjCBridged
{
    @NSManaged
    var selector: Selector
}

@objc
internal final class ArchivableEnumFloatingPointAccessorObjCBridged:
    ArchivableEnumObjCBridged
{
    @NSManaged
    var doubleValue: Double
    
    @NSManaged
    var floatValue: Float
}

@objc
internal final class ArchivableEnumFoundationAccessorObjCBridged:
    ArchivableEnumObjCBridged
{
    @NSManaged
    var rangeValue: NSRange
}

@objc
internal final class ArchivableEnumCGAccessorObjCBridged:
    ArchivableEnumObjCBridged
{
    @NSManaged
    var CGPointValue: CGPoint
    
    @NSManaged
    var CGVectorValue: CGVector
    
    @NSManaged
    var CGSizeValue: CGSize
    
    @NSManaged
    var CGRectValue: CGRect
    
    @NSManaged
    var CGAffineTransformValue: CGAffineTransform
}

#if os(iOS) || os(watchOS) || os(tvOS)
@objc
internal final class ArchivableEnumUIKitAccessorObjCBridged:
    ArchivableEnumObjCBridged
{
    @NSManaged
    var offset: UIOffset
    
    @NSManaged
    var edgeInsets: UIEdgeInsets
}
#endif

#if os(iOS) || os(OSX) || os(tvOS)
@objc
internal final class ArchivableEnumQuartzCoreAccessorObjCBridged:
    ArchivableEnumObjCBridged
{
    @NSManaged
    var CATransform3DValue: CATransform3D
}

@objc
internal final class ArchivableEnumAVFoundationAccessorObjCBridged:
    ArchivableEnumObjCBridged
{
    @NSManaged
    var CMTimeValue: CMTime
    
    @NSManaged
    var CMTimeRangeValue: CMTimeRange
    
    @NSManaged
    var CMTimeMappingValue: CMTimeMapping
}
#endif
