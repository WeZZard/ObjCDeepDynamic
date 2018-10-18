//
//  ObjCDynamicCoded.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

#import <ObjCDeepDynamic/ObjCDynamicObject+Subclass.h>
#import <ObjCDeepDynamic/ObjCDynamicCoding.h>

#import "ObjCDynamicCoding+Internal.h"

#import "ObjCDynamicCoded.h"

static NSString *  kObjCDynamicCoderVersionKey = @"com.WeZZard.ObjCDeepDynamic.ObjCDynamicCoded.version";

@implementation ObjCDynamicCoded
+ (NSInteger)version {
    return 0;
}

+ (BOOL)migrateValue:(id  _Nullable __autoreleasing *)value
              forKey:(NSString *__autoreleasing  _Nonnull *)key
                from:(NSInteger)fromVersion
                  to:(NSInteger)toVersion
{
#if DEBUG
    NSLog(@"Trying to migrate value(\"%@\") for key \"%@\" from version \"\%@\" to version \"%@\" but did nothing with it. You may override %@ with your migration code.", [*value description], [*key description], @(fromVersion), @(toVersion), NSStringFromSelector(_cmd));
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
        
        NSInteger binaryVersion = [aDecoder decodeIntegerForKey:kObjCDynamicCoderVersionKey];
        
        BOOL shouldMigrate = classVersion != binaryVersion;
        
        BOOL isEntireMigrationSucceeded = YES;
        
        Class inspectedClass = [self class];
        
        Class rootClass = [ObjCDynamicCoded class];
        
        while (inspectedClass != rootClass) {
            
            unsigned int propertyCount = 0;
            
            objc_property_t * propertyList = class_copyPropertyList(inspectedClass, &propertyCount);
            
            for (unsigned int index = 0; index < propertyCount; index ++) {
                objc_property_t property = propertyList[index];
                
                char * isDynamicAttribute = property_copyAttributeValue(property, "D");
                
                if (isDynamicAttribute) {
                    const char * rawPropertyName = property_getName(property);
                    
                    NSString * propertyName = [NSString stringWithCString:rawPropertyName
                                                                 encoding:NSUTF8StringEncoding];
                    
                    ObjCDynamicCodingDecodeCallBack decode = ObjCDynamicCodingGetDecodeCallBackForPropertyName([self class], propertyName);
                    
                    id value = (* decode)([self class], aDecoder, propertyName);
                    
                    if (shouldMigrate) {
                        BOOL isValueMigrationSucceeded = [[self class] migrateValue:&value
                                                                             forKey:&propertyName
                                                                               from:binaryVersion
                                                                                 to:classVersion];
                        
                        isEntireMigrationSucceeded = isEntireMigrationSucceeded && isValueMigrationSucceeded;
                    } else {
                        if (value == nil) {
                            id defaultValue = [[self class] defaultValueForKey:propertyName];
                            
                            if (defaultValue != nil) {
                                value = defaultValue;
                            }
                        }
                    }
                    
                    if (propertyName != nil) {
                        [self setValue:value forKey:propertyName];
                    }
                    
                    free(isDynamicAttribute);
                }
            }
            
            free(propertyList);
            
            inspectedClass = [inspectedClass superclass];
        }
        
        if (shouldMigrate && !isEntireMigrationSucceeded) {
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
