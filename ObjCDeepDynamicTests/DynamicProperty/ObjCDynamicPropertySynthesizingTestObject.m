//
//  ObjCDynamicPropertySynthesizingTestObject.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 16/10/2018.
//

#import "ObjCDynamicPropertySynthesizingTestObject.h"


@implementation ObjCDynamicPropertySynthesizingTestObject
@dynamic object;
@dynamic objectCopy;
@dynamic objectWeak;

@dynamic objectNonatomic;
@dynamic objectCopyNonatomic;
@dynamic objectWeakNonatomic;

@dynamic charValueNonatomic;
@dynamic intValueNonatomic;
@dynamic shortValueNonatomic;
@dynamic longValueNonatomic;
@dynamic longLongValueNonatomic;

@dynamic floatValueNonatomic;
@dynamic doubleValueNonatomic;

@dynamic boolValueNonatomic;
@dynamic rangeValueNonatomic;

@dynamic charValue;
@dynamic intValue;
@dynamic shortValue;
@dynamic longValue;
@dynamic longLongValue;

@dynamic floatValue;
@dynamic doubleValue;

@dynamic boolValue;
@dynamic rangeValue;

- (NSMutableDictionary<NSString *,id> *)storage {
    if (_storage == nil) {
        _storage = [[NSMutableDictionary alloc] init];
    }
    return _storage;
}

- (void)setPrimitiveValue:(nullable id)primitiveValue forKey:(NSString *)key
{
    self.storage[key] = primitiveValue;
}

- (nullable id)primitiveValueForKey:(NSString *)key {
    return self.storage[key];
}
@end
