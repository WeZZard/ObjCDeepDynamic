//
//  _OBJCDDWeakValue.h
//  ObjCDeepDynamic
//
//  Created on 17/10/2018.
//

#import "_OBJCDDValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface _OBJCDDWeakValue : _OBJCDDValue
- (instancetype)initWithObject:(id)object;
@property (nonatomic, weak, nullable) id object;
@end

NS_ASSUME_NONNULL_END
