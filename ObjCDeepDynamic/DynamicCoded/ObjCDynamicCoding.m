//
//  ObjCDynamicCoding.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 2/25/16.
//
//

@import ObjectiveC;

#import "ObjCDynamicCoding.h"

#pragma mark - Type
typedef struct _ObjCDynamicCodingCodingCallBacks {
    const char * typeIdentifier;
    const size_t typeIdentifierLength;
    const ObjCDynamicCodingDecodeCallBack decodeCallBack;
    const ObjCDynamicCodingEncodeCallBack encodeCallBack;
} ObjCDynamicCodingCodingCallBacks;

#pragma mark - Function Prototypes
static const ObjCDynamicCodingCodingCallBacks * ObjCDynamicCodingCodingCallBacksCreate(
    const char *,
    const ObjCDynamicCodingDecodeCallBack,
    const ObjCDynamicCodingEncodeCallBack
);

static void ObjCDynamicCodingCodingCallBacksRelease(ObjCDynamicCodingCodingCallBacks *);

/// Returns true when their `typeIdentifier`s are same.
static Boolean ObjCDynamicCodingCodingCallBacksEqual(const void *, const void *);

#pragma mark Coding
static id ObjCDynamicCodingDefaultDecodeCallBack (Class, NSCoder *, NSString *);
static void ObjCDynamicCodingDefaultEncodeCallBack (Class, NSCoder *, NSString *, id);

#pragma mark Internal Utilities
static ObjCDynamicCodingCodingCallBacks * ObjCDynamicCodingGetCodingCallBacksForTypeEncoding(
    const char *
);

#pragma mark - Variables
static CFArrayCallBacks ObjCDynamicCodingCodingCallBackArrayCallBacks = {
    0,
    NULL,
    NULL,
    NULL,
    &ObjCDynamicCodingCodingCallBacksEqual
};

static CFMutableArrayRef kRegisteredCodingCallBacks = NULL;

/** The default implementation of decode call-back.
 
 -Dicussion: The default decode call-back takes Foundation's mechanism(
 `NSCoder`'s special taking for `NSNumber`) into consideration. It decodes 
 values with `NSCoder`'s `-decodeObjectForKey:`. But for those `NSValue` and 
 non-`NSNumber` values, the call-back would convert them from `NSData` instances 
 at first.
 */
static const ObjCDynamicCodingDecodeCallBack kObjCDynamicCodingDefaultDecodeCallBack
= &ObjCDynamicCodingDefaultDecodeCallBack;

/** The default implementation of encode call-back.
 
 -Dicussion: The default encode call-back takes Foundation's mechanism(
 `NSCoder`'s special treatment for `NSNumber`) into consideration. It encodes
 values with `NSCoder`'s `-encodeObject:forKey:`. But for those `NSValue` 
 wrapped non-`NSNumber` values, the call-back would convert them into `NSData` 
 instances at first.
 */
static const ObjCDynamicCodingEncodeCallBack kObjCDynamicCodingDefaultEncodeCallBack
= &ObjCDynamicCodingDefaultEncodeCallBack;

#pragma mark - Function Implmentation
#pragma mark Register Coding Call-Back
const ObjCDynamicCodingCodingCallBacks * ObjCDynamicCodingCodingCallBacksCreate(
    const char * typeIdentifier,
    const ObjCDynamicCodingDecodeCallBack decodeCallBack,
    const ObjCDynamicCodingEncodeCallBack encodeCallback
    )
{
    size_t typeIdentifierLength = strlen(typeIdentifier);

    ObjCDynamicCodingCodingCallBacks * codingCallBack
    = malloc(sizeof(ObjCDynamicCodingCodingCallBacks));

    size_t typeIdentifierSize = sizeof(char) * typeIdentifierLength;

    char * copiedTypeIdentifier = malloc(typeIdentifierSize);

    memcpy(copiedTypeIdentifier, typeIdentifier, typeIdentifierSize);

    * codingCallBack = (ObjCDynamicCodingCodingCallBacks){
        copiedTypeIdentifier,
        typeIdentifierLength,
        decodeCallBack,
        encodeCallback
    };

    return codingCallBack;
}

void ObjCDynamicCodingCodingCallBacksRelease(
    ObjCDynamicCodingCodingCallBacks * callBack
    )
{
    free((void *)callBack -> typeIdentifier);
    free(callBack);
}

Boolean ObjCDynamicCodingCodingCallBacksEqual(
    const void * value1,
    const void * value2
    )
{
    ObjCDynamicCodingCodingCallBacks * lhs
    = (ObjCDynamicCodingCodingCallBacks *)value1;
    ObjCDynamicCodingCodingCallBacks * rhs
    = (ObjCDynamicCodingCodingCallBacks *)value2;

    return lhs -> typeIdentifierLength == rhs -> typeIdentifierLength &&
        strcmp(lhs -> typeIdentifier, rhs -> typeIdentifier) == 0;
}

BOOL ObjCDynamicCodingRegisterCodingCallBacks(
    const char * typeIdentifier,
    const ObjCDynamicCodingDecodeCallBack decodeCallBack,
    const ObjCDynamicCodingEncodeCallBack encodeCallBack
    )
{
    NSCAssert(decodeCallBack != NULL, @"decode call-back cannot be NULL");
    NSCAssert(encodeCallBack != NULL, @"encode call-back cannot be NULL");
    
    const ObjCDynamicCodingCodingCallBacks * codingCallBack
    = ObjCDynamicCodingCodingCallBacksCreate(
        typeIdentifier,
        decodeCallBack,
        encodeCallBack
    );

    if (kRegisteredCodingCallBacks == NULL) {
        kRegisteredCodingCallBacks = CFArrayCreateMutable(
            kCFAllocatorDefault,
            0,
            &ObjCDynamicCodingCodingCallBackArrayCallBacks
        );
        NSCAssert(
            kRegisteredCodingCallBacks != NULL,
            @"Initialize kRegisteredCodingCallBacks failed."
        );
    }

    CFIndex count = CFArrayGetCount(kRegisteredCodingCallBacks);

    if (CFArrayContainsValue(
            kRegisteredCodingCallBacks,
            CFRangeMake(0, count),
            codingCallBack
            )
        )
    {
#if DEBUG
        NSLog(
            @"Duplicate ObjCDynamicCoding coding call back registration for property of type %s",
            typeIdentifier
        );
#endif
        ObjCDynamicCodingCodingCallBacksRelease((void *)codingCallBack);
        return NO;
    } else {
        CFArrayAppendValue(kRegisteredCodingCallBacks, codingCallBack);
        return YES;
    }
}

#pragma mark Coding
id ObjCDynamicCodingDefaultDecodeCallBack (
    Class aClass,
    NSCoder * coder,
    NSString * key
    )
{
    id decodedValue = [coder decodeObjectForKey:key];

    // A special conversion for `NSData` `decodedValue` instance
    if ([decodedValue isKindOfClass:[NSData class]]) {
        NSData * decodedData = decodedValue;

        objc_property_t property = class_getProperty(aClass, [key UTF8String]);

        const char * propertyTypeEncoding
        = property_copyAttributeValue(property, "T");

        static const char * identityEncoding = @encode(NSData);

        const size_t identifierEncodingLength = strlen(identityEncoding);

        // Only works for the properties which are not type of `NSData`
        if (strncmp(
                propertyTypeEncoding,
                identityEncoding,
                identifierEncodingLength
            ) != 0)
        {

            // Continue to filter natively supported `NSNumber`s out

            // I don't want count the omitted encodings manually, use a `NULL`
            // terminated array instead.
            static const char * omittedEncodings[] = {
                @encode(char),
                @encode(int),
                @encode(short),
#ifdef __LP64__
                "l",
#else
                @encode(long),
#endif
                @encode(long long),
                @encode(unsigned char),
                @encode(unsigned int),
                @encode(unsigned short),
                @encode(unsigned long),
                @encode(unsigned long long),
                @encode(BOOL),
                @encode(double),
                @encode(float),
                NULL
            };

            int currentOmittedEncodingIndex = 0;
            const char * currentOmittedEncoding
            = omittedEncodings[currentOmittedEncodingIndex];

            while (currentOmittedEncoding) {
                size_t currentOmittedEncodingLength
                = strlen(currentOmittedEncoding);

                if (strncmp(
                        propertyTypeEncoding,
                        currentOmittedEncoding,
                        currentOmittedEncodingLength
                    ) == 0)
                {
                    free((char *)propertyTypeEncoding);
                    return decodedValue;
                }

                currentOmittedEncodingIndex += 1;
                currentOmittedEncoding
                = omittedEncodings[currentOmittedEncodingIndex];
            }
            
            NSUInteger size = 0;
            NSGetSizeAndAlignment(propertyTypeEncoding, &size, NULL);

            // Deal with `NSData` -> `NSValue` conversion
            void * rawData = malloc(decodedData.length);
            memset(rawData, 0, size);

            [decodedData getBytes:rawData length:decodedData.length];

            NSValue * value = [NSValue valueWithBytes:rawData
                                             objCType:propertyTypeEncoding];

            free(rawData);
            free((char *)propertyTypeEncoding);

            return value;
        }

        free((char *)propertyTypeEncoding);
    }

    return decodedValue;
}

void ObjCDynamicCodingDefaultEncodeCallBack (
    Class aClass,
    NSCoder * coder,
    NSString * key,
    id value
    )
{
    if ([value isKindOfClass:[NSValue class]]
        && ![value isKindOfClass:[NSNumber class]])
    {
        NSUInteger size = 0;
        const char * encoding = [value objCType];
        NSGetSizeAndAlignment(encoding, &size, NULL);

        void * rawData = malloc(size);
        memset(rawData, 0, size);
        if (@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)) {
            [value getValue:rawData size:size];
        } else {
            [value getValue:rawData];
        }

        NSData * data = [NSData dataWithBytes:rawData length:size];

        free(rawData);

        [coder encodeObject:data forKey:key];
    } else {
        [coder encodeObject:value forKey:key];
    }
}

ObjCDynamicCodingEncodeCallBack ObjCDynamicCodingGetEncodeCallBackForPropertyName(
    const Class aClass,
    const NSString * propertyName
    )
{
    objc_property_t property = class_getProperty(
        aClass,
        [propertyName UTF8String]
    );

    const char * propertyTypeEncoding
    = property_copyAttributeValue(property, "T");

    ObjCDynamicCodingCodingCallBacks * targetedCodingCallBack
    = ObjCDynamicCodingGetCodingCallBacksForTypeEncoding(propertyTypeEncoding);

    free((char *)propertyTypeEncoding);

    if (targetedCodingCallBack == NULL) {
        return kObjCDynamicCodingDefaultEncodeCallBack;
    } else {
        return targetedCodingCallBack -> encodeCallBack;
    }
}

ObjCDynamicCodingDecodeCallBack ObjCDynamicCodingGetDecodeCallBackForPropertyName(
    const Class aClass,
    const NSString * propertyName
    )
{
    objc_property_t property = class_getProperty(
        aClass,
        [propertyName UTF8String]
    );

    const char * propertyTypeEncoding
    = property_copyAttributeValue(property, "T");

    ObjCDynamicCodingCodingCallBacks * targetedCodingCallBack
    = ObjCDynamicCodingGetCodingCallBacksForTypeEncoding(propertyTypeEncoding);

    free((char *)propertyTypeEncoding);

    if (targetedCodingCallBack == NULL) {
        return kObjCDynamicCodingDefaultDecodeCallBack;
    } else {
        return targetedCodingCallBack -> decodeCallBack;
    }
}

#pragma mark Internal Utilities
ObjCDynamicCodingCodingCallBacks * ObjCDynamicCodingGetCodingCallBacksForTypeEncoding(
    const char * typeEncoding
    )
{
    CFIndex count = CFArrayGetCount(kRegisteredCodingCallBacks);

    ObjCDynamicCodingCodingCallBacks * targetedCodingCallBack = NULL;

    for (CFIndex index = 0; index < count; index ++) {
        const void * value = CFArrayGetValueAtIndex(
            kRegisteredCodingCallBacks,
            index
        );

        const ObjCDynamicCodingCodingCallBacks * codingCallBack = value;

        if (strncmp(
                codingCallBack -> typeIdentifier,
                typeEncoding,
                codingCallBack -> typeIdentifierLength
            ) == 0
            )
        {
            targetedCodingCallBack
            = (ObjCDynamicCodingCodingCallBacks *)codingCallBack;
        }

        if (targetedCodingCallBack != NULL) {
            break;
        }
    }

    return targetedCodingCallBack;
}
