//
//  ObjCDynamicCoder.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

#import <ObjCDeepDynamic/ObjCDynamicObject+Subclass.h>
#import <ObjCDeepDynamic/ObjCDynamicCoding.h>

#import "ObjCDynamicCoding+Internal.h"

#import "ObjCDynamicCoder.h"

static NSString *  kObjCDynamicCoderVersionKey = @"com.WeZZard.ObjCDeepDynamic.ObjCDynamicCoder.version";

@implementation ObjCDynamicCoder
+ (NSInteger)version {
    return 0;
}

+ (BOOL)migrateValue:(id  _Nullable __autoreleasing *)value
              forKey:(NSString *__autoreleasing  _Nonnull *)key
                from:(NSInteger)fromVersion
                  to:(NSInteger)toVersion
{
#if DEBUG
    NSLog(@"Trying to migrate value(\"%@\") for key \"%@\" but does nothing with it. You might override %@ to migrate.", [*value description], [*key description], NSStringFromSelector(_cmd));
#endif
    return NO;
}

+ (id)defaultValueForKey:(NSString *)key {
    if ([key isEqualToString:NSStringFromSelector(@selector(version))]) {
        return 0;
    }
    return nil;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        NSInteger classVersion = [[self class] version];
        
        NSInteger binaryVersion
        = [aDecoder decodeIntegerForKey:kObjCDynamicCoderVersionKey];
        
        BOOL shouldMigrate = classVersion != binaryVersion;
        
        BOOL isWholeMigrationSucceeded = YES;
        
        Class inspectedClass = [self class];
        
        Class searchingTerminateClass = [ObjCDynamicCoder class];
        
        while (inspectedClass != searchingTerminateClass) {
            
            unsigned int propertyCount = 0;
            
            objc_property_t * propertyList
            = class_copyPropertyList(inspectedClass, &propertyCount);
            
            for (unsigned int index = 0; index < propertyCount; index ++) {
                objc_property_t property = propertyList[index];
                
                if (property_copyAttributeValue(property, "D")) {
                    const char * rawPropertyName = property_getName(property);
                    
                    NSString * propertyName
                    = [NSString stringWithCString:rawPropertyName
                                         encoding:NSUTF8StringEncoding];
                    
                    ObjCDynamicCodingDecodeCallBack decode
                    = ObjCDynamicCodingGetDecodeCallBackForPropertyName([self class], propertyName);
                    
                    id value = (* decode)([self class], aDecoder, propertyName);
                    
                    if (shouldMigrate) {
                        BOOL isValueMigrationSucceeded
                        = [[self class] migrateValue:&value
                                              forKey:&propertyName
                                                from:binaryVersion
                                                  to:classVersion];
                        
                        isWholeMigrationSucceeded
                        = isWholeMigrationSucceeded && isValueMigrationSucceeded;
                    } else {
                        if (value == nil) {
                            id defaultValue
                            = [[self class] defaultValueForKey:propertyName];
                            
                            if (defaultValue != nil) {
                                value = defaultValue;
                            }
                        }
                    }
                    
                    if (propertyName != nil) {
                        [self setValue:value forKey:propertyName];
                    }
                }
            }
            
            free(propertyList);
            
            inspectedClass = [inspectedClass superclass];
        }
        
        if (shouldMigrate && !isWholeMigrationSucceeded) {
            return nil;
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:[[self class] version] forKey:kObjCDynamicCoderVersionKey];
    
    for (NSString * key in self.internalStorage) {
        id value = [self.internalStorage objectForKey: key];
        
        ObjCDynamicCodingEncodeCallBack encode
        = ObjCDynamicCodingGetEncodeCallBackForPropertyName([self class], key);
        
        (* encode)([self class], coder, key, value);
    }
}
@end
