//
//  ObjCDynamicObject.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

#import "ObjCDynamicObject.h"

@interface ObjCDynamicObject()
@property (nonatomic, readwrite, strong) NSMutableDictionary<NSString *, id> * internalStorage;

static inline void ObjCDynamicObjectLoadInternalStorageIfNeeded(ObjCDynamicObject * self);
@end

@implementation ObjCDynamicObject
- (NSMutableDictionary<NSString *,id> *)internalStorage {
    ObjCDynamicObjectLoadInternalStorageIfNeeded(self);
    return _internalStorage;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)setPrimitiveValue:(nullable id)primitiveValue forKey:(NSString *)key
{
    ObjCDynamicObjectLoadInternalStorageIfNeeded(self);
    [_internalStorage setObject: primitiveValue forKey: key];
}

- (nullable id)primitiveValueForKey:(NSString *)key {
    ObjCDynamicObjectLoadInternalStorageIfNeeded(self);
    return [_internalStorage objectForKey: key];
}

- (id)copyWithZone:(NSZone *)zone
{
    ObjCDynamicObject * copied = [[[self class] allocWithZone:zone] init];
    copied -> _internalStorage = [[NSMutableDictionary alloc] initWithDictionary:_internalStorage copyItems:YES];
    return copied;
}

static inline void ObjCDynamicObjectLoadInternalStorageIfNeeded(ObjCDynamicObject * self) {
    if (self -> _internalStorage == nil) {
        self -> _internalStorage = [[NSMutableDictionary alloc] init];
    }
}
@end
