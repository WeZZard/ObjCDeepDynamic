//
//  ObjCDynamicCoding-AppKit.m
//  ObjCDeepDynamic
//
//  Created on 17/10/2018.
//

@import ObjectiveC;
@import Foundation;
@import CoreGraphics;
@import AppKit;

#import <ObjCDeepDynamic/MacroUtilities.h>
#import "ObjCDynamicCoding.h"

/// Represents `NSPoint` and `NSSize`
typedef struct _NSFloat2 {
    CGFloat member1;
    CGFloat member2;
} NSFloat2;

static id DecodeNSPoint (Class, NSCoder *, NSString *);
static void EncodeNSPoint (Class, NSCoder *, NSString *, id);

static id DecodeNSSize (Class, NSCoder *, NSString *);
static void EncodeNSSize (Class, NSCoder *, NSString *, id);

static id DecodeNSRect (Class, NSCoder *, NSString *);
static void EncodeNSRect (Class, NSCoder *, NSString *, id);

#pragma mark - Register
_OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY
static void ObjCDynamicCodingLoadCustomCallBacks() {
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(NSPoint),
        &DecodeNSPoint,
        &EncodeNSPoint
    );
    
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(NSSize),
        &DecodeNSSize,
        &EncodeNSSize
    );
    
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(NSRect),
        &DecodeNSRect,
        &EncodeNSRect
    );
}

#pragma mark Coding
id DecodeNSPoint (Class aClass, NSCoder * decoder, NSString * key) {
    NSPoint point = [decoder decodePointForKey: key];
    return [NSValue valueWithPoint: point];
}

void EncodeNSPoint (Class aClass, NSCoder * coder, NSString * key, id value) {
    NSPoint point = [value pointValue];
    [coder encodePoint:point forKey:key];
}

id DecodeNSSize (Class aClass, NSCoder * decoder, NSString * key) {
    NSSize size = [decoder decodeSizeForKey: key];
    return [NSValue valueWithSize: size];
}

void EncodeNSSize (Class aClass, NSCoder * coder, NSString * key, id value) {
    NSSize size = [value sizeValue];
    [coder encodeSize:size forKey:key];
}

id DecodeNSRect (Class aClass, NSCoder * decoder, NSString * key) {
    NSRect rect = [decoder decodeRectForKey: key];
    return [NSValue valueWithRect: rect];
}

void EncodeNSRect (Class aClass, NSCoder * coder, NSString * key, id value) {
    NSRect rect = [value rectValue];
    [coder encodeRect:rect forKey:key];
}
