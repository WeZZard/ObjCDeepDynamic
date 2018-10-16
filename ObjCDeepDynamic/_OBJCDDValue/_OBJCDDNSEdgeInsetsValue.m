//
//  _OBJCDDNSEdgeInsetsValue.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 16/10/2018.
//

#import "_OBJCDDNSEdgeInsetsValue.h"

@interface _OBJCDDNSEdgeInsetsValue() {
    NSEdgeInsets _edgeInsets;
}
@end

@implementation _OBJCDDNSEdgeInsetsValue
- (instancetype)initWithNSEdgeInsets:(NSEdgeInsets)edgeInsets {
    self = [super init];
    if (self) {
        _edgeInsets = edgeInsets;
    }
    return self;
}

- (NSEdgeInsets)NSEdgeInsetsValue {
    return _edgeInsets;
}

- (id)copyWithZone:(NSZone *)zone {
    _OBJCDDNSEdgeInsetsValue * copied = [super copyWithZone: zone];
    copied -> _edgeInsets = _edgeInsets;
    return copied;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
#if __LP64__
        CGFloat top = [aDecoder decodeDoubleForKey: @"_edgeInsets.top"];
        CGFloat left = [aDecoder decodeDoubleForKey: @"_edgeInsets.left"];
        CGFloat bottom = [aDecoder decodeDoubleForKey: @"_edgeInsets.bottom"];
        CGFloat right = [aDecoder decodeDoubleForKey: @"_edgeInsets.right"];
#else
        CGFloat top = [aDecoder decodeFloatForKey: @"_edgeInsets.top"];
        CGFloat left = [aDecoder decodeFloatForKey: @"_edgeInsets.left"];
        CGFloat bottom = [aDecoder decodeFloatForKey: @"_edgeInsets.bottom"];
        CGFloat right = [aDecoder decodeFloatForKey: @"_edgeInsets.right"];
#endif
        _edgeInsets = NSEdgeInsetsMake(top, left, bottom, right);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
#if __LP64__
    [aCoder encodeDouble: _edgeInsets.top forKey: @"_edgeInsets.top"];
    [aCoder encodeDouble: _edgeInsets.left forKey: @"_edgeInsets.left"];
    [aCoder encodeDouble: _edgeInsets.bottom forKey: @"_edgeInsets.bottom"];
    [aCoder encodeDouble: _edgeInsets.right forKey: @"_edgeInsets.right"];
#else
    [aCoder encodeFloat: _edgeInsets.top forKey: @"_edgeInsets.top"];
    [aCoder encodeFloat: _edgeInsets.left forKey: @"_edgeInsets.left"];
    [aCoder encodeFloat: _edgeInsets.bottom forKey: @"_edgeInsets.bottom"];
    [aCoder encodeFloat: _edgeInsets.right forKey: @"_edgeInsets.right"];
#endif
}
@end
