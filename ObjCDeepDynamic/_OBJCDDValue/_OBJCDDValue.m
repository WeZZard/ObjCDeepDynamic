//
//  _OBJCDDValue.m
//  ObjCDeepDynamic
//
//  Created on 17/10/2018.
//

#import "_OBJCDDValue.h"
#import "_OBJCDDWeakValue.h"

@implementation _OBJCDDValue
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
