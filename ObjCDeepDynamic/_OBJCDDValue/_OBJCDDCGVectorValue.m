//
//  _OBJCDDCGVectorValue.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 16/10/2018.
//

#import "_OBJCDDCGVectorValue.h"

@interface _OBJCDDCGVectorValue() {
    CGVector _vector;
}
@end

@implementation _OBJCDDCGVectorValue
- (instancetype)initWithCGVector:(CGVector)vector {
    self = [super init];
    if (self) {
        _vector = vector;
    }
    return self;
}

- (CGVector)CGVectorValue {
    return _vector;
}

- (id)copyWithZone:(NSZone *)zone {
    _OBJCDDCGVectorValue * copied = [super copyWithZone: zone];
    copied -> _vector = _vector;
    return copied;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
#if __LP64__
        CGFloat dx = [aDecoder decodeDoubleForKey: @"_vector.dx"];
        CGFloat dy = [aDecoder decodeDoubleForKey: @"_vector.dy"];
#else
        CGFloat dx = [aDecoder decodeFloatForKey: @"_vector.dx"];
        CGFloat dy = [aDecoder decodeFloatForKey: @"_vector.dy"];
#endif
        _vector = CGVectorMake(dx, dy);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
#if __LP64__
    [aCoder encodeDouble: _vector.dx forKey: @"_vector.dx"];
    [aCoder encodeDouble: _vector.dy forKey: @"_vector.dy"];
#else
    [aCoder encodeFloat: _vector.dx forKey: @"_vector.dx"];
    [aCoder encodeFloat: _vector.dy forKey: @"_vector.dy"];
#endif
}
@end
