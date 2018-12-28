//
//  _OBJCDDWeakValue.h
//  ObjCDeepDynamic
//
//  Created on 17/10/2018.
//

#import "_OBJCDDValue.h"

NS_ASSUME_NONNULL_BEGIN

#if TARGET_CPU_X86 || TARGET_CPU_X86_64
@interface _OBJCDDWeakValue : _OBJCDDValue
- (instancetype)initWithObject:(id)object;
@property (nonatomic, weak, nullable) id object;
@end
#endif

NS_ASSUME_NONNULL_END
