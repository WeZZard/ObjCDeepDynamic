//
//  _OBJCDDValue.h
//  ObjCDeepDynamic
//
//  Created on 17/10/2018.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _OBJCDDValue : NSObject<NSCopying, NSSecureCoding>
+ (_OBJCDDValue *)valueWithWeakObject:(id)object;
- (nullable id)weakObject;
@end

NS_ASSUME_NONNULL_END
