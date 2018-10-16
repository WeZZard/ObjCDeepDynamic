//
//  ObjCDynamicPropertySynthesizing.h
//  ObjCDeepDynamic
//
//  Created by WeZZard on 24/12/2016.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/// Classes conform to `ObjCDynamicPropertySynthesizing` are enabled to
/// synthesize @dynamic property itself.
@protocol ObjCDynamicPropertySynthesizing <NSObject>

/// Used by -setValue:forKey: to access dynamic property content.
- (void)setPrimitiveValue:(nullable id)primitiveValue forKey:(NSString *)key;

/// Used by -valueForKey: to access dynamic property content.
- (nullable id)primitiveValueForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
