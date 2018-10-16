//
//  ObjCDynamicObject+Subclass.h
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

#import <ObjCDeepDynamic/ObjCDynamicObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjCDynamicObject (Subclass)
@property (nonatomic, readwrite, strong) NSMutableDictionary<NSString *, id> * internalStorage;
@end

NS_ASSUME_NONNULL_END
