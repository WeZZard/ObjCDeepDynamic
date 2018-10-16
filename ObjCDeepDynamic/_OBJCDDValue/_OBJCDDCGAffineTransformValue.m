//
//  _OBJCDDCGAffineTransformValue.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 16/10/2018.
//

#import "_OBJCDDCGAffineTransformValue.h"

@interface _OBJCDDCGAffineTransformValue() {
    CGAffineTransform _affineTransform;
}
@end

@implementation _OBJCDDCGAffineTransformValue
- (instancetype)initWithCGAffineTransform:(CGAffineTransform)affineTransform {
    self = [super init];
    if (self) {
        _affineTransform = affineTransform;
    }
    return self;
}

- (CGAffineTransform)CGAffineTransformValue {
    return _affineTransform;
}

- (id)copyWithZone:(NSZone *)zone {
    _OBJCDDCGAffineTransformValue * copied = [super copyWithZone: zone];
    copied -> _affineTransform = _affineTransform;
    return copied;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
#if __LP64__
        CGFloat a = [aDecoder decodeDoubleForKey: @"_affineTransform.a"];
        CGFloat b = [aDecoder decodeDoubleForKey: @"_affineTransform.b"];
        CGFloat c = [aDecoder decodeDoubleForKey: @"_affineTransform.c"];
        CGFloat d = [aDecoder decodeDoubleForKey: @"_affineTransform.d"];
        CGFloat tx = [aDecoder decodeDoubleForKey: @"_affineTransform.tx"];
        CGFloat ty = [aDecoder decodeDoubleForKey: @"_affineTransform.ty"];
#else
        CGFloat a = [aDecoder decodeFloatForKey: @"_affineTransform.a"];
        CGFloat b = [aDecoder decodeFloatForKey: @"_affineTransform.b"];
        CGFloat c = [aDecoder decodeFloatForKey: @"_affineTransform.c"];
        CGFloat d = [aDecoder decodeFloatForKey: @"_affineTransform.d"];
        CGFloat tx = [aDecoder decodeFloatForKey: @"_affineTransform.tx"];
        CGFloat ty = [aDecoder decodeFloatForKey: @"_affineTransform.ty"];
#endif
        _affineTransform = CGAffineTransformMake(a, b, c, d, tx, ty);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
#if __LP64__
    [aCoder encodeDouble: _affineTransform.a forKey: @"_affineTransform.a"];
    [aCoder encodeDouble: _affineTransform.b forKey: @"_affineTransform.b"];
    [aCoder encodeDouble: _affineTransform.c forKey: @"_affineTransform.c"];
    [aCoder encodeDouble: _affineTransform.d forKey: @"_affineTransform.d"];
    [aCoder encodeDouble: _affineTransform.tx forKey: @"_affineTransform.tx"];
    [aCoder encodeDouble: _affineTransform.ty forKey: @"_affineTransform.ty"];
#else
    [aCoder encodeFloat: _affineTransform.a forKey: @"_affineTransform.a"];
    [aCoder encodeFloat: _affineTransform.b forKey: @"_affineTransform.b"];
    [aCoder encodeFloat: _affineTransform.c forKey: @"_affineTransform.c"];
    [aCoder encodeFloat: _affineTransform.d forKey: @"_affineTransform.d"];
    [aCoder encodeFloat: _affineTransform.tx forKey: @"_affineTransform.tx"];
    [aCoder encodeFloat: _affineTransform.ty forKey: @"_affineTransform.ty"];
#endif
}
@end
