//
//  ObjCDynamicPropertySynthesizing.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 24/12/2016.
//
//

#import <objc/message.h>

#import <dlfcn.h>

#import "fishhook.h"

#import "ObjCDynamicPropertySynthesizer+Internal.h"
#import "ObjCDynamicPropertySynthesizing.h"

#import "ObjCDynamicPropertySynthesizer.h"

NS_ASSUME_NONNULL_BEGIN
#pragma mark - Function Prototypes
typedef BOOL NSObjectResolveInstanceMethod (id, SEL, SEL);
static NSObjectResolveInstanceMethod * kNSObjectResolveInstanceMethodOriginal;
static NSObjectResolveInstanceMethod NSObjectResolveInstanceMethodSwizzled;

typedef id NSObjectValueForKey (id, SEL, NSString *);
static NSObjectValueForKey * kNSObjectValueForKeyOriginal;
static NSObjectValueForKey NSObjectValueForKeySwizzled;

typedef void NSObjectSetValueForKey (id, SEL, id, NSString *);
static NSObjectSetValueForKey * kNSObjectSetValueForKeyOriginal;
static NSObjectSetValueForKey NSObjectSetValueForKeySwizzled;

typedef BOOL ClassAddPropertyFunc (Class cls, const char * name, const objc_property_attribute_t * attributes, unsigned int attributeCount);
static ClassAddPropertyFunc * kClass_addPropertyOriginal;
static ClassAddPropertyFunc class_addPropertyRebound;
static void class_didAddProperty(Class cls, const char * name, const objc_property_attribute_t * attributes, unsigned int attributeCount, BOOL succeeded);

typedef BOOL ClassAddProtocolFunc (Class cls, Protocol *);
static ClassAddProtocolFunc * kClass_addProtocolOriginal;
static ClassAddProtocolFunc class_addProtocolRebound;
static void class_didAddProtocol(Class cls, Protocol * name, BOOL succeeded);

_OBJCDD_MODULE_CONSTRUCTOR_LOW_PRIORITY
static void InjectDynamicPropertySynthesizer() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Rebind class_addProperty
        kClass_addPropertyOriginal = (ClassAddPropertyFunc *) dlsym(RTLD_DEFAULT, "class_addProperty");
        
        void * addPropertyReplacement = (void *)&class_addPropertyRebound;
        void * * addPropertyReplaced = (void * *)&kClass_addPropertyOriginal;
        
        struct rebinding rebindForClass_addProperty = {
            "class_addProperty",
            addPropertyReplacement,
            addPropertyReplaced,
        };
        
#if DEBUG
        if (rebind_symbols(&rebindForClass_addProperty, 1) == 0) {
            NSLog(@"Rebind class_addProperty succeeded.");
        } else {
            NSLog(@"Rebind class_addProperty failed.");
        }
#else
        rebind_symbols(&rebindForClass_addProperty, 1);
#endif
        
        // Rebind class_addProtocol
        kClass_addProtocolOriginal = (ClassAddProtocolFunc *) dlsym(RTLD_DEFAULT, "class_addProtocol");
        
        void * addProtocolReplacement = (void *)&class_addProtocolRebound;
        void * * addProtocolReplaced = (void * *)&kClass_addProtocolOriginal;
        
        struct rebinding rebindForClass_addProtocol = {
            "class_addProtocol",
            addProtocolReplacement,
            addProtocolReplaced,
        };
        
#if DEBUG
        if (rebind_symbols(&rebindForClass_addProtocol, 1) == 0) {
            NSLog(@"Rebind class_addProtocol succeeded.");
        } else {
            NSLog(@"Rebind class_addProtocol failed.");
        }
#else
        rebind_symbols(&rebindForClass_addProtocol, 1);
#endif
        
        // Swizzle -valueForKey:
        Method valueForKey = class_getInstanceMethod([NSObject class], @selector(valueForKey:));
        kNSObjectValueForKeyOriginal = (NSObjectValueForKey *)method_getImplementation(valueForKey);
        method_setImplementation(valueForKey, (IMP)&NSObjectValueForKeySwizzled);
        
        // Swizzle -setValue:forKey:
        Method setValueForKey = class_getInstanceMethod([NSObject class], @selector(setValue:forKey:));
        kNSObjectSetValueForKeyOriginal = (NSObjectSetValueForKey *)method_getImplementation(setValueForKey);
        method_setImplementation(setValueForKey, (IMP)&NSObjectSetValueForKeySwizzled);
        
        // Swizzle +resolveInstanceMethod:
        Method resolveInstanceMethod = class_getClassMethod([NSObject class], @selector(resolveInstanceMethod:));
        kNSObjectResolveInstanceMethodOriginal = (NSObjectResolveInstanceMethod *)method_getImplementation(resolveInstanceMethod);
        method_setImplementation(resolveInstanceMethod, (IMP)&NSObjectResolveInstanceMethodSwizzled);
    });
}

void NSObjectSetValueForKeySwizzled (id self, SEL _cmd, id value, NSString * key) {
    if ([self conformsToProtocol:@protocol(ObjCDynamicPropertySynthesizing)]) {
        if (objcdd::ObjCDynamicPropertySynthesizer::shared().isDynamicProperty([self class], key)) {
            id <ObjCDynamicPropertySynthesizing> dynamic = self;
            [dynamic setPrimitiveValue:value forKey:key];
            return;
        }
    }
    
    (* kNSObjectSetValueForKeyOriginal)(self, _cmd, value, key);
}

id NSObjectValueForKeySwizzled (id self, SEL _cmd, NSString * key) {
    if ([self conformsToProtocol:@protocol(ObjCDynamicPropertySynthesizing)]) {
        if (objcdd::ObjCDynamicPropertySynthesizer::shared().isDynamicProperty([self class], key)) {
            id <ObjCDynamicPropertySynthesizing> dynamic = self;
            return [dynamic primitiveValueForKey:key];
        }
    }
    
    return (* kNSObjectValueForKeyOriginal)(self, _cmd, key);
}

BOOL NSObjectResolveInstanceMethodSwizzled(id self, SEL _cmd, SEL selector) {
    if ([self conformsToProtocol:@protocol(ObjCDynamicPropertySynthesizing)]) {
        if (objcdd::ObjCDynamicPropertySynthesizer::shared().synthesizeProperty([self class], selector)) {
            return YES;
        }
    }
    return (* kNSObjectResolveInstanceMethodOriginal)(self, _cmd, selector);
}

BOOL class_addPropertyRebound(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount) {
    BOOL succeeded = (* kClass_addPropertyOriginal)(cls, name, attributes, attributeCount);
    class_didAddProperty(cls, name, attributes, attributeCount, succeeded);
    return succeeded;
}

void class_didAddProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount, BOOL succeeded) {
    if (succeeded && objcdd::ObjCDynamicPropertySynthesizer::shared().isClassPrepared(cls)) {
        objcdd::ObjCDynamicPropertySynthesizer::shared().classDidAddProperty(cls, name, attributes, attributeCount);
    }
}

BOOL class_addProtocolRebound(Class cls, Protocol * protocol) {
    BOOL succeeded = (* kClass_addProtocolOriginal)(cls, protocol);
    class_didAddProtocol(cls, protocol, succeeded);
    return succeeded;
}

void class_didAddProtocol(Class cls, Protocol * protocol, BOOL succeeded) {
    if (succeeded && objcdd::ObjCDynamicPropertySynthesizer::shared().isClassPrepared(cls)) {
        objcdd::ObjCDynamicPropertySynthesizer::shared().classDidAddProtocol(cls, protocol);
    }
}

NS_ASSUME_NONNULL_END
