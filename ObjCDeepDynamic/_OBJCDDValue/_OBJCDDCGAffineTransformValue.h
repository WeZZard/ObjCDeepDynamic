//
//  _OBJCDDCGAffineTransformValue.h
//  ObjCDeepDynamic
//
//  Created by WeZZard on 16/10/2018.
//

#import "_OBJCDDValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface _OBJCDDCGAffineTransformValue : _OBJCDDValue
- (instancetype)initWithCGAffineTransform:(CGAffineTransform)affineTransform;
- (CGAffineTransform)CGAffineTransformValue;
@end

NS_ASSUME_NONNULL_END
