//
//  _OBJCDDNSEdgeInsetsValue.h
//  ObjCDeepDynamic
//
//  Created by WeZZard on 16/10/2018.
//

#import "_OBJCDDValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface _OBJCDDNSEdgeInsetsValue : _OBJCDDValue
- (instancetype)initWithNSEdgeInsets:(NSEdgeInsets)edgeInsets;
- (NSEdgeInsets)NSEdgeInsetsValue;
@end

NS_ASSUME_NONNULL_END
