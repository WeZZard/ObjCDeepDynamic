//
//  ObjCDynamicCoding-CoreGraphics(Cocoa).m
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

/// Represents `CGPoint`, `CGVector` and `CGSize`
typedef struct _CGFloat2 {
    CGFloat member1;
    CGFloat member2;
} CGFloat2;

static id DecodeCGVector (Class, NSCoder *, NSString *);
static void EncodeCGVector (Class, NSCoder *, NSString *, id);

static id DecodeCGAffineTransform (Class, NSCoder *, NSString *);
static void EncodeCGAffineTransform (Class, NSCoder *, NSString *, id);

#pragma mark - Register
_OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY
static void ObjCDynamicCodingLoadCustomCallBacks() {
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(CGVector),
        &DecodeCGVector,
        &EncodeCGVector
    );
    
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(CGAffineTransform),
        &DecodeCGAffineTransform,
        &EncodeCGAffineTransform
    );
}

#pragma mark Coding
id DecodeCGVector (Class aClass, NSCoder * decoder, NSString * key) {
    NSValue * vector = [decoder decodeObjectForKey:key];
    return vector;
}

void EncodeCGVector (Class aClass, NSCoder * coder, NSString * key, id value) {
    [coder encodeObject:value forKey:key];
}

id DecodeCGAffineTransform (Class aClass, NSCoder * decoder, NSString * key) {
    NSValue * transform = [decoder decodeObjectForKey:key];
    return transform;
}

void EncodeCGAffineTransform (Class aClass, NSCoder * coder, NSString * key, id value) {
    [coder encodeObject:value forKey:key];
}
