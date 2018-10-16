//
//  _OBJCDDValue.m
//  ObjCDeepDynamic
//
//  Created on 17/10/2018.
//

#import "_OBJCDDValue.h"
#import "_OBJCDDNSEdgeInsetsValue.h"
#import "_OBJCDDCGVectorValue.h"
#import "_OBJCDDCGAffineTransformValue.h"
#import "_OBJCDDWeakValue.h"

@implementation _OBJCDDValue
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

+ (_OBJCDDValue *)valueWithWeakObject:(id)object {
    return [[_OBJCDDWeakValue alloc] initWithObject: object];
}

- (nullable id)weakObject {
    [NSException raise: NSInvalidArgumentException format: @"Abstract class."];
    exit(1);
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [[[self class] allocWithZone: zone] init];
}

+ (BOOL)supportsSecureCoding {
    return NO;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
