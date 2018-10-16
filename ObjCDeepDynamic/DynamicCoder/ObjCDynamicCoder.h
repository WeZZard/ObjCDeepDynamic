//
//  ObjCDynamicCoder.h
//  ObjCDeepDynamic
//
//  Created by WeZZard on 26/12/2016.
//
//

#import <ObjCDeepDynamic/ObjCDynamicObject.h>

NS_ASSUME_NONNULL_BEGIN

/// `ObjCDynamicCoder` understands how to encode and decode its @dynamic
/// properties.
@interface ObjCDynamicCoder : ObjCDynamicObject<NSCoding>
/** Returns the version of `ObjCDynamicCoder` subclass. The default
 implementaiton always returns 0.
 
 - Discussion: With the default implementation, the decoding would be
 failed if the decoded version is different from the value got in this
 method and any value migration was failed.
 */
+ (NSInteger)version;

/** Offers a lightweight migration mechanism. Returns `NO` by default.
 
 @param     value           The value to migrate.
 
 @param     key             The key of the value to migrate. Set to nil to
 make the decoding ommitted this value.
 
 @param     fromVersion     The old archived binary version.
 
 @param     toVersion       Current class version.
 
 @return    A flag indicates the migration succeeded or failed.
 */
+ (BOOL)migrateValue:(id _Nullable * _Nonnull)value
              forKey:(NSString * _Nullable * _Nonnull)key
                from:(NSInteger)fromVersion
                  to:(NSInteger)toVersion;

/** Returns a fallback value for a non-migration decoding a property named
 `key`. */
+ (nullable id)defaultValueForKey:(NSString *)key;

- (instancetype)init;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;

- (void)encodeWithCoder:(NSCoder *)aCoder;
@end

NS_ASSUME_NONNULL_END
