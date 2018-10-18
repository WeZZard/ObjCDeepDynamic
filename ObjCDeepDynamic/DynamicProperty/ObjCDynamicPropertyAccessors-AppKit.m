//
//  ObjCDynamicPropertyAccessors-AppKit.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 06/01/2017.
//
//

@import Foundation;
@import AppKit;
@import CoreGraphics;

#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizer.h>
#import "_OBJCDDValue+AppKit.h"


@ObjCDynamicPropertyGetter(NSPoint) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] pointValue];
    }
};

@ObjCDynamicPropertySetter(NSPoint) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithPoint:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(NSSize) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] sizeValue];
    }
};

@ObjCDynamicPropertySetter(NSSize) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithSize:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(NSRect) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] rectValue];
    }
};

@ObjCDynamicPropertySetter(NSRect) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithRect:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(NSEdgeInsets) {
    @synchronized (self) {
        if (@available(macOS 10.10, *)) {
            return [[self primitiveValueForKey:_prop] edgeInsets];
        } else {
            return [[self primitiveValueForKey:_prop] NSEdgeInsetsValue];
        }
    }
};

@ObjCDynamicPropertySetter(NSEdgeInsets) {
    @synchronized (self) {
        if (@available(macOS 10.10, *)) {
            [self setPrimitiveValue:[NSValue valueWithEdgeInsets:newValue] forKey:_prop];
        } else {
            [self setPrimitiveValue:[_OBJCDDValue valueWithEdgeInsets:newValue] forKey:_prop];
        }
    }
};

@ObjCDynamicPropertyGetter(NSPoint, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] pointValue];
};

@ObjCDynamicPropertySetter(NSPoint, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithPoint:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(NSSize, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] sizeValue];
};

@ObjCDynamicPropertySetter(NSSize, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithSize:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(NSRect, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] rectValue];
};

@ObjCDynamicPropertySetter(NSRect, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithRect:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(NSEdgeInsets, NONATOMIC) {
    if (@available(macOS 10.10, *)) {
        return [[self primitiveValueForKey:_prop] edgeInsetsValue];
    } else {
        return [[self primitiveValueForKey:_prop] NSEdgeInsetsValue];
    }
};

@ObjCDynamicPropertySetter(NSEdgeInsets, NONATOMIC) {
    if (@available(macOS 10.10, *)) {
        [self setPrimitiveValue:[NSValue valueWithEdgeInsets:newValue] forKey:_prop];
    } else {
        [self setPrimitiveValue:[_OBJCDDValue valueWithEdgeInsets:newValue] forKey:_prop];
    }
};
