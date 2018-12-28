//
//  _OBJCDDFloat80Value.m
//  ObjCDeepDynamic
//
//  Created on 28/12/2018.
//

#import "_OBJCDDFloat80Value.h"

@interface _OBJCDDFloat80Value() {
    long double _float80Value;
}
@end

@implementation _OBJCDDFloat80Value
- (instancetype)initWithFloat80:(long double)float80Value {
    self = [super init];
    if (self) {
        _float80Value = float80Value;
    }
    return self;
}

- (long double)float80Value {
    return _float80Value;
}

- (void)setFloat80Value:(long double)float80Value {
    if (_float80Value != float80Value) {
        _float80Value = float80Value;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    _OBJCDDFloat80Value * copied = [super copyWithZone: zone];
    copied -> _float80Value = _float80Value;
    return copied;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        NSUInteger length = 0;
        long double * float80ValuePtr = (long double *)[aDecoder decodeBytesForKey: @"float80Value" returnedLength: &length];
        _float80Value = * float80ValuePtr;
        NSAssert(length == (NSUInteger)sizeof(_float80Value), @"Unmatches length of Float80.");
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBytes: (void *)&_float80Value length: sizeof(_float80Value) forKey: @"float80Value"];
}
@end
