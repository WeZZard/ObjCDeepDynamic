//
//  ObjCDynamicPropertyAccessors-CoreGraphics(CocoaTouch).m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

@import Foundation;
@import CoreGraphics;
@import UIKit;

#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizer.h>


@ObjCDynamicPropertyGetter(CGPoint) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CGPointValue];
    }
};

@ObjCDynamicPropertySetter(CGPoint) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithCGPoint:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CGVector) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CGVectorValue];
    }
};

@ObjCDynamicPropertySetter(CGVector) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithCGVector:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CGSize) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CGSizeValue];
    }
};

@ObjCDynamicPropertySetter(CGSize) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithCGSize:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CGRect) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CGRectValue];
    }
};

@ObjCDynamicPropertySetter(CGRect) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithCGRect:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CGAffineTransform) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CGAffineTransformValue];
    }
};

@ObjCDynamicPropertySetter(CGAffineTransform) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithCGAffineTransform:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CGPoint, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CGPointValue];
};

@ObjCDynamicPropertySetter(CGPoint, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithCGPoint:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(CGVector, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CGVectorValue];
};

@ObjCDynamicPropertySetter(CGVector, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithCGVector:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(CGSize, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CGSizeValue];
};

@ObjCDynamicPropertySetter(CGSize, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithCGSize:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(CGRect, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CGRectValue];
};

@ObjCDynamicPropertySetter(CGRect, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithCGRect:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(CGAffineTransform, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CGAffineTransformValue];
};

@ObjCDynamicPropertySetter(CGAffineTransform, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithCGAffineTransform:newValue] forKey:_prop];
};
