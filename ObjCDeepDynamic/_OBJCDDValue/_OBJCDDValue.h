//
//  _OBJCDDValue.h
//  ObjCDeepDynamic
//
//  Created on 17/10/2018.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _OBJCDDValue : NSObject<NSCopying, NSSecureCoding>
+ (_OBJCDDValue *)valueWithEdgeInsets:(NSEdgeInsets)edgeInsets;
- (NSEdgeInsets)NSEdgeInsetsValue;

+ (_OBJCDDValue *)valueWithVector:(CGVector)vector;
- (CGVector)CGVectorValue;

+ (_OBJCDDValue *)valueWithAffineTransform:(CGAffineTransform)affineTransform;
- (CGAffineTransform)CGAffineTransformValue;

+ (_OBJCDDValue *)valueWithWeakObject:(id)object;
- (nullable id)weakObject;
@end

NS_ASSUME_NONNULL_END
