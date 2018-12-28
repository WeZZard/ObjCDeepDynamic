//
//  _OBJCDDFloat80Value.h
//  ObjCDeepDynamic
//
//  Created on 28/12/2018.
//

#import "_OBJCDDValue.h"

NS_ASSUME_NONNULL_BEGIN

#if TARGET_CPU_X86 || TARGET_CPU_X86_64
@interface _OBJCDDFloat80Value : _OBJCDDValue
- (instancetype)initWithFloat80:(long double)float80Value;
@property (nonatomic, assign) long double float80Value;
@end
#endif

NS_ASSUME_NONNULL_END
