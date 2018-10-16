//
//  _OBJCDDCGVectorValue.h
//  ObjCDeepDynamic
//
//  Created by WeZZard on 16/10/2018.
//

#import "_OBJCDDValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface _OBJCDDCGVectorValue : _OBJCDDValue
- (instancetype)initWithCGVector:(CGVector)vector;
- (CGVector)CGVectorValue;
@end

NS_ASSUME_NONNULL_END
