//
//  _OBJCDDValue+AppKit.h
//  ObjCDeepDynamic
//
//  Created on 18/10/2018.
//

#import "_OBJCDDValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface _OBJCDDValue (AppKit)
+ (_OBJCDDValue *)valueWithEdgeInsets:(NSEdgeInsets)edgeInsets;
- (NSEdgeInsets)NSEdgeInsetsValue;

+ (_OBJCDDValue *)valueWithVector:(CGVector)vector;
- (CGVector)CGVectorValue;

+ (_OBJCDDValue *)valueWithAffineTransform:(CGAffineTransform)affineTransform;
- (CGAffineTransform)CGAffineTransformValue;
@end

NS_ASSUME_NONNULL_END
