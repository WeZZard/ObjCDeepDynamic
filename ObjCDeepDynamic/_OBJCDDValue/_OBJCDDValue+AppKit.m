//
//  _OBJCDDValue+AppKit.m
//  ObjCDeepDynamic
//
//  Created on 18/10/2018.
//

#import "_OBJCDDValue+AppKit.h"
#import "_OBJCDDNSEdgeInsetsValue.h"
#import "_OBJCDDCGVectorValue.h"
#import "_OBJCDDCGAffineTransformValue.h"

@implementation _OBJCDDValue (AppKit)
+ (_OBJCDDValue *)valueWithEdgeInsets:(NSEdgeInsets)edgeInsets {
    return [[_OBJCDDNSEdgeInsetsValue alloc] initWithNSEdgeInsets: edgeInsets];
}

- (NSEdgeInsets)NSEdgeInsetsValue {
    [NSException raise: NSInvalidArgumentException format: @"Abstract class."];
    exit(1);
}

+ (_OBJCDDValue *)valueWithVector:(CGVector)vector {
    return [[_OBJCDDCGVectorValue alloc] initWithCGVector: vector];
}

- (CGVector)CGVectorValue {
    [NSException raise: NSInvalidArgumentException format: @"Abstract class."];
    exit(1);
}

+ (_OBJCDDValue *)valueWithAffineTransform:(CGAffineTransform)affineTransform {
    return [[_OBJCDDCGAffineTransformValue alloc] initWithCGAffineTransform: affineTransform];
}

- (CGAffineTransform)CGAffineTransformValue {
    [NSException raise: NSInvalidArgumentException format: @"Abstract class."];
    exit(1);
}
@end
