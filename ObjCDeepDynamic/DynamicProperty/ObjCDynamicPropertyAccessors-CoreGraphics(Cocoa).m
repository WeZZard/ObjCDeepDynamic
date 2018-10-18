//
//  ObjCDynamicPropertyAccessors-CoreGraphics.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

@import Foundation;
@import CoreGraphics;

#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizer.h>
#import "_OBJCDDValue+AppKit.h"


@ObjCDynamicPropertyGetter(CGVector) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CGVectorValue];
    }
};

@ObjCDynamicPropertySetter(CGVector) {
    @synchronized (self) {
        [self setPrimitiveValue:[_OBJCDDValue valueWithVector:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CGAffineTransform) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CGAffineTransformValue];
    }
};

@ObjCDynamicPropertySetter(CGAffineTransform) {
    @synchronized (self) {
        [self setPrimitiveValue:[_OBJCDDValue valueWithAffineTransform:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CGVector, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CGVectorValue];
};

@ObjCDynamicPropertySetter(CGVector, NONATOMIC) {
    [self setPrimitiveValue:[_OBJCDDValue valueWithVector:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(CGAffineTransform, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CGAffineTransformValue];
};

@ObjCDynamicPropertySetter(CGAffineTransform, NONATOMIC) {
    [self setPrimitiveValue:[_OBJCDDValue valueWithAffineTransform:newValue] forKey:_prop];
};
