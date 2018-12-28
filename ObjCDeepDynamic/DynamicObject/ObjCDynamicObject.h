//
//  ObjCDynamicObject.h
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

#import <Foundation/Foundation.h>
#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizing.h>

NS_ASSUME_NONNULL_BEGIN

/// `ObjCDynamicObject` automatically synthesizes all the `@dynamic`
/// properties.
///
@interface ObjCDynamicObject : NSObject<
    ObjCDynamicPropertySynthesizing, NSCopying
>
- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
