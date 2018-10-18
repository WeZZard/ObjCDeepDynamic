//
//  ObjCDynamicPropertyAccessors-CoreMedia.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

@import CoreMedia;
@import AVFoundation;

#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizer.h>

@ObjCDynamicPropertyGetter(CMTime) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CMTimeValue];
    }
};

@ObjCDynamicPropertySetter(CMTime) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithCMTime:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CMTime, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CMTimeValue];
};

@ObjCDynamicPropertySetter(CMTime, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithCMTime:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(CMTimeRange) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CMTimeRangeValue];
    }
};

@ObjCDynamicPropertySetter(CMTimeRange) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithCMTimeRange:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CMTimeRange, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CMTimeRangeValue];
};

@ObjCDynamicPropertySetter(CMTimeRange, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithCMTimeRange:newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(CMTimeMapping) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] CMTimeMappingValue];
    }
};

@ObjCDynamicPropertySetter(CMTimeMapping) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithCMTimeMapping:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(CMTimeMapping, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] CMTimeMappingValue];
};

@ObjCDynamicPropertySetter(CMTimeMapping, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithCMTimeMapping:newValue] forKey:_prop];
};
