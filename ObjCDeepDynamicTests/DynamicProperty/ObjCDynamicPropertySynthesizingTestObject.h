//
//  ObjCDynamicPropertySynthesizingTestObject.h
//  ObjCDeepDynamic
//
//  Created by WeZZard on 16/10/2018.
//

#import <Foundation/Foundation.h>
#import <ObjCDeepDynamic/ObjCDeepDynamic.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjCDynamicPropertySynthesizingTestObject : NSObject<ObjCDynamicPropertySynthesizing> {
    NSMutableDictionary<NSString *, id> * _storage;
}
@property (strong) id __nullable object;
@property (copy) id __nullable objectCopy;
@property (weak) id __nullable objectWeak;

@property (nonatomic, strong) id __nullable objectNonatomic;
@property (nonatomic, copy) id __nullable objectCopyNonatomic;
@property (nonatomic, weak) id __nullable objectWeakNonatomic;

@property (nonatomic, assign) char charValueNonatomic;
@property (nonatomic, assign) int intValueNonatomic;
@property (nonatomic, assign) short shortValueNonatomic;
@property (nonatomic, assign) long longValueNonatomic;
@property (nonatomic, assign) long long longLongValueNonatomic;

@property (nonatomic, assign) float floatValueNonatomic;
@property (nonatomic, assign) double doubleValueNonatomic;

@property (nonatomic, assign) BOOL boolValueNonatomic;

@property (nonatomic, assign) NSRange rangeValueNonatomic;

@property (assign) char charValue;
@property (assign) int intValue;
@property (assign) short shortValue;
@property (assign) long longValue;
@property (assign) long long longLongValue;

@property (assign) float floatValue;
@property (assign) double doubleValue;

@property (assign) BOOL boolValue;

@property (assign) NSRange rangeValue;
@end

NS_ASSUME_NONNULL_END
