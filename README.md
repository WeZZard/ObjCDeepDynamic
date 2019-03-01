# ObjCDeepDynamic

[![Build Status](https://travis-ci.com/WeZZard/ObjCDeepDynamic.svg?branch=master)](https://travis-ci.com/WeZZard/ObjCDeepDynamic)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

ObjCDeepDynamic is an Objective-C/Swift framework eases the pain of
implementing dumbly data classes by automatically synthesizing `@dynamic`
properties and (optionally) conforming to `NSCoding`.

## Features

- An out-of-box base class supports `@dynamic` property auto synthesizing.
- An out-of-box base class supports `@dynamic` property auto synthesizing
  with `NSCoding` implemented.
- Enriching auto synthesizing supported types for `@dynamic` property.
- Quickly implementing your dynamic property auto synthesize-able classes.

## Example: Dynamic Property Synthesizing

Objective-C

```objc
#import <Foundation/Foundation.h>
#import <ObjCDeepDynamic/ObjCDeepDynamic.h>

@interface Config: ObjCDynamicObject
@property (nonatomic, copy) NSString configName;
@property (nonatomic, assign) NSUInteger temperature;
@end

@implementation Config
@dynamic configName
@dynamic temperature
@end
```

Swift

```swift
import ObjCDeepDynamic

class Config: ObjCDynamicObject {
    @NSManaged var configName: String
    @NSManaged var temperature: Int
}
```

## Example: Dynamic Property Synthesizing and NSCoding Auto Implementing

Objective-C

```objc
#import <Foundation/Foundation.h>
#import <ObjCDeepDynamic/ObjCDeepDynamic.h>

@interface Config: ObjCDynamicCoded
@property (nonatomic, copy) NSString configName;
@property (nonatomic, assign) NSUInteger temperature;
@end

@implementation Config
@dynamic configName
@dynamic temperature
@end
```

Swift

```swift
import ObjCDeepDynamic

class Config: ObjCDynamicCoded {
    @NSManaged var configName: String
    @NSManaged var temperature: Int
}
```

## Wiki

- [Wiki Home](https://github.com/WeZZard/ObjCDeepDynamic/wiki)

### Out-of-Box Features

- [ObjCDynamicObject](https://github.com/WeZZard/ObjCDeepDynamic/wiki/ObjCDynamicObject)
- [ObjCDynamicCoded](https://github.com/WeZZard/ObjCDeepDynamic/wiki/ObjCDynamicCoded)

### Advanced Features

- [Enrich Auto Synthesizable @dynamic Property Types](https://github.com/WeZZard/ObjCDeepDynamic/wiki/Enrich-Auto-Synthesizable-%40dynamic-Property-Types)
- [Custom Class Dynamic Property Auto Synthesizing](https://github.com/WeZZard/ObjCDeepDynamic/wiki/Custom-Class-Dynamic-Property-Auto-Synthesizing)

## License
MIT