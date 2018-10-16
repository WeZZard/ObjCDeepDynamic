//
//  _OBJCDDWeakValue.m
//  ObjCDeepDynamic
//
//  Created on 17/10/2018.
//

#import "_OBJCDDWeakValue.h"

@interface _OBJCDDWeakValue() {
    __weak id _object;
}
@end

@implementation _OBJCDDWeakValue
- (instancetype)initWithObject:(id)object {
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}

- (id)object {
    return _object;
}

- (void)setObject:(id)object {
    if (_object != object) {
        _object = object;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    _OBJCDDWeakValue * copied = [super copyWithZone: zone];
    copied -> _object = _object;
    return copied;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _object = [aDecoder decodeObjectForKey: @"object"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeConditionalObject: _object forKey: @"object"];
}
@end
