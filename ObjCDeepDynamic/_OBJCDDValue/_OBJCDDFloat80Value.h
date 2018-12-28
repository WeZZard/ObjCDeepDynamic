//
//  _OBJCDDFloat80Value.h
//  ObjCDeepDynamic
//
//  Created on 28/12/2018.
//

#import "_OBJCDDValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface _OBJCDDFloat80Value : _OBJCDDValue
- (instancetype)initWithFloat80:(long double)float80Value;
@property (nonatomic, assign) long double float80Value;
@end

NS_ASSUME_NONNULL_END
