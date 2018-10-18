//
//  ObjCDynamicCoding+Internal.h
//  ObjCDeepDynamic
//
//  Created by WeZZard on 27/12/2016.
//
//

#import <ObjCDeepDynamic/ObjCDynamicCoding.h>

FOUNDATION_EXTERN ObjCDynamicCodingEncodeCallBack ObjCDynamicCodingGetEncodeCallBackForPropertyName(const Class, const NSString *);

FOUNDATION_EXTERN ObjCDynamicCodingDecodeCallBack ObjCDynamicCodingGetDecodeCallBackForPropertyName(const Class, const NSString *);
