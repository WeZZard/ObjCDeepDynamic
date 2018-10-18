//
//  ObjCDynamicPropertyAccessors-QuartzCore.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

@import Foundation;

#if TARGET_OS_IOS
@import UIKit;
#elif TARGET_OS_TV
@import UIKit;
#elif TARGET_OS_OSX
@import AppKit;
#endif

@import QuartzCore;

#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizer.h>

@ObjCDynamicPropertyGetter(CATransform3D) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CATransform3DValue];
    }
};

@ObjCDynamicPropertySetter(CATransform3D) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithCATransform3D:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CATransform3D, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CATransform3DValue];
};

@ObjCDynamicPropertySetter(CATransform3D, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithCATransform3D:newValue] forKey:_prop];
};
