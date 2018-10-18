//
//  ObjCDynamicCoding-AVFoundation.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 2/28/16.
//
//

@import Foundation;
@import ObjectiveC;
@import AVFoundation;

#import <ObjCDeepDynamic/MacroUtilities.h>
#import "ObjCDynamicCoding.h"

static id DecodeCMTime (Class, NSCoder *, NSString *);

static void EncodeCMTime (Class, NSCoder *, NSString *, id);

static id DecodeCMTimeRange (Class, NSCoder *, NSString *);

static void EncodeCMTimeRange (Class, NSCoder *, NSString *, id);

static id DecodeCMTimeMapping (Class, NSCoder *, NSString *);

static void EncodeCMTimeMapping (Class, NSCoder *, NSString *, id);

#pragma mark - Register
_OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY
static void ObjCDynamicCodingLoadCustomCallBacks() {
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(CMTime),
        &DecodeCMTime,
        &EncodeCMTime
    );
    
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(CMTimeRange),
        &DecodeCMTimeRange,
        &EncodeCMTimeRange
    );
    
    ObjCDynamicCodingRegisterCodingCallBacks(
        @encode(CMTimeMapping),
        &DecodeCMTimeMapping,
        &EncodeCMTimeMapping
    );
}

id DecodeCMTime (Class aClass, NSCoder * decoder, NSString * key) {
    CMTime time = [decoder decodeCMTimeForKey: key];
    
    return [NSValue valueWithCMTime:time];
}

void EncodeCMTime (Class aClass, NSCoder * coder, NSString * key, id value) {
    CMTime time = [value CMTimeValue];
    
    [coder encodeCMTime:time forKey:key];
}

id DecodeCMTimeRange (Class aClass, NSCoder * decoder, NSString * key) {
    CMTimeRange timeRange = [decoder decodeCMTimeRangeForKey: key];
    
    return [NSValue valueWithCMTimeRange:timeRange];
}

void EncodeCMTimeRange (Class aClass, NSCoder * coder, NSString * key, id value) {
    CMTimeRange timeRange = [value CMTimeRangeValue];
    
    [coder encodeCMTimeRange:timeRange forKey:key];
}

id DecodeCMTimeMapping (Class aClass, NSCoder * decoder, NSString * key) {
    CMTimeMapping timeMapping = [decoder decodeCMTimeMappingForKey: key];
    
    return [NSValue valueWithCMTimeMapping:timeMapping];
}

void EncodeCMTimeMapping (Class aClass, NSCoder * coder, NSString * key, id value) {
    CMTimeMapping timeMapping = [value CMTimeMappingValue];
    
    [coder encodeCMTimeMapping:timeMapping forKey:key];
}
