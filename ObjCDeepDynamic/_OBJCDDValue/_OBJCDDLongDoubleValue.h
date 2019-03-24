//
//  _OBJCDDLongDoubleValue.h
//  ObjCDeepDynamic
//
//  Created on 28/12/2018.
//

#import "_OBJCDDValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface _OBJCDDLongDoubleValue : _OBJCDDValue
- (instancetype)initWithLongDouble:(long double)longDoubleValue;
@property (nonatomic, assign) long double longDoubleValue;
@end

NS_ASSUME_NONNULL_END
