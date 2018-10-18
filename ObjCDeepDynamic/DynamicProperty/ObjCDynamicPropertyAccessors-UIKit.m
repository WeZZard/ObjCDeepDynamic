//
//  ObjCDynamicPropertyAccessors-UIKit.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

@import UIKit;

#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizer.h>

@ObjCDynamicPropertyGetter(UIOffset) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] UIOffsetValue];
    }
};

@ObjCDynamicPropertyGetter(UIOffset, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] UIOffsetValue];
};

@ObjCDynamicPropertySetter(UIOffset) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithUIOffset:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertySetter(UIOffset, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithUIOffset:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(UIEdgeInsets) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] UIEdgeInsetsValue];
    }
};

@ObjCDynamicPropertyGetter(UIEdgeInsets, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] UIEdgeInsetsValue];
};

@ObjCDynamicPropertySetter(UIEdgeInsets) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithUIEdgeInsets:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertySetter(UIEdgeInsets, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithUIEdgeInsets:newValue] forKey:_prop];
};
