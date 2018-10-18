//
//  ObjCDynamicCoding-CoreGraphics(CocoaTouch).m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 2/25/16.
//
//

@import ObjectiveC;
@import Foundation;
@import CoreGraphics;
@import UIKit;

#import <ObjCDeepDynamic/MacroUtilities.h>
#import "ObjCDynamicCoding.h"

/// Represents `CGPoint`, `CGVector` and `CGSize`
typedef struct _CGFloat2 {
    CGFloat member1;
    CGFloat member2;
} CGFloat2;

static id DecodeCGPoint (Class, NSCoder *, NSString *);
static void EncodeCGPoint (Class, NSCoder *, NSString *, id);

static id DecodeCGVector (Class, NSCoder *, NSString *);
static void EncodeCGVector (Class, NSCoder *, NSString *, id);

static id DecodeCGSize (Class, NSCoder *, NSString *);
static void EncodeCGSize (Class, NSCoder *, NSString *, id);

static id DecodeCGRect (Class, NSCoder *, NSString *);
static void EncodeCGRect (Class, NSCoder *, NSString *, id);

static id DecodeCGAffineTransform (Class, NSCoder *, NSString *);
static void EncodeCGAffineTransform (Class, NSCoder *, NSString *, id);

#pragma mark - Register
_OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY
static void ObjCDynamicCodingLoadCustomCallBacks() {
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(CGPoint),
        &DecodeCGPoint,
        &EncodeCGPoint
    );
    
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(CGSize),
        &DecodeCGSize,
        &EncodeCGSize
    );
    
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(CGVector),
        &DecodeCGVector,
        &EncodeCGVector
    );
    
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(CGRect),
        &DecodeCGRect,
        &EncodeCGRect
    );
    
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(CGAffineTransform),
        &DecodeCGAffineTransform,
        &EncodeCGAffineTransform
    );
}

#pragma mark Coding
id DecodeCGPoint (Class aClass, NSCoder * decoder, NSString * key) {
    CGPoint point = [decoder decodeCGPointForKey:key];
    return [NSValue valueWithCGPoint:point];
}

void EncodeCGPoint (Class aClass, NSCoder * coder, NSString * key, id value) {
    CGPoint point = [value CGPointValue];
    [coder encodeCGPoint:point forKey:key];
}

id DecodeCGVector (Class aClass, NSCoder * decoder, NSString * key) {
    CGVector vector = [decoder decodeCGVectorForKey:key];
    return [NSValue valueWithCGVector:vector];
}

void EncodeCGVector (Class aClass, NSCoder * coder, NSString * key, id value) {
    CGVector vector = [value CGVectorValue];
    [coder encodeCGVector:vector forKey:key];
}

id DecodeCGSize (Class aClass, NSCoder * decoder, NSString * key) {
    CGSize size = [decoder decodeCGSizeForKey:key];
    return [NSValue valueWithCGSize:size];
}

void EncodeCGSize (Class aClass, NSCoder * coder, NSString * key, id value) {
    CGSize size = [value CGSizeValue];
    [coder encodeCGSize:size forKey:key];
}

id DecodeCGRect (Class aClass, NSCoder * decoder, NSString * key) {
    CGRect rect = [decoder decodeCGRectForKey:key];
    return [NSValue valueWithCGRect:rect];
}

void EncodeCGRect (Class aClass, NSCoder * coder, NSString * key, id value) {
    CGRect rect = [value CGRectValue];
    [coder encodeCGRect:rect forKey:key];
}

id DecodeCGAffineTransform (Class aClass, NSCoder * decoder, NSString * key) {
    CGAffineTransform transform = [decoder decodeCGAffineTransformForKey:key];
    return [NSValue valueWithCGAffineTransform:transform];
}

void EncodeCGAffineTransform (Class aClass, NSCoder * coder, NSString * key, id value) {
    CGAffineTransform transform = [value CGAffineTransformValue];
    [coder encodeCGAffineTransform:transform forKey:key];
}
