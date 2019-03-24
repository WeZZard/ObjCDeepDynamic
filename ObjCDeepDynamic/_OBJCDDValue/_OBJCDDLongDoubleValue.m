//
//  _OBJCDDLongDoubleValue.m
//  ObjCDeepDynamic
//
//  Created on 28/12/2018.
//

#import "_OBJCDDLongDoubleValue.h"

@interface _OBJCDDLongDoubleValue() {
    long double _longDoubleValue;
}
@end

@implementation _OBJCDDLongDoubleValue
- (instancetype)initWithLongDouble:(long double)longDoubleValue {
    self = [super init];
    if (self) {
        _longDoubleValue = longDoubleValue;
    }
    return self;
}

- (long double)longDoubleValue {
    return _longDoubleValue;
}

- (void)setLongDoubleValue:(long double)longDoubleValue {
    if (_longDoubleValue != longDoubleValue) {
        _longDoubleValue = longDoubleValue;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    _OBJCDDLongDoubleValue * copied = [super copyWithZone: zone];
    copied -> _longDoubleValue = _longDoubleValue;
    return copied;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        NSUInteger length = 0;
        long double * float80ValuePtr = (long double *)[aDecoder decodeBytesForKey: @"longDoubleValue" returnedLength: &length];
        _longDoubleValue = * float80ValuePtr;
        NSAssert(length == (NSUInteger)sizeof(_longDoubleValue), @"Unmatches length of long double.");
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBytes: (void *)&_longDoubleValue length: sizeof(_longDoubleValue) forKey: @"longDoubleValue"];
}
@end
