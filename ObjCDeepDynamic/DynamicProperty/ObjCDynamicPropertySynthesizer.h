//
//  ObjCDynamicPropertySynthesizer.h
//  ObjCDeepDynamic
//
//  Created by WeZZard on 25/12/2016.
//
//

#ifndef ObjCDynamicPropertySynthesizer_h
#define ObjCDynamicPropertySynthesizer_h

#import <Foundation/Foundation.h>
#import <ObjCDeepDynamic/metamacros.h>
#import <ObjCDeepDynamic/MacroUtilities.h>
#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizing.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ObjCDynamicPropertyAttributes
typedef NS_OPTIONS(NSInteger, ObjCDynamicPropertyAttributes) {
    ObjCDynamicPropertyAttributeNone = 0,
    ObjCDynamicPropertyAttributeCopy = 1 << 0,
    ObjCDynamicPropertyAttributeRetain = 1 << 1,
    ObjCDynamicPropertyAttributeNonatomic = 1 << 2,
    ObjCDynamicPropertyAttributeWeak = 1 << 3
} NS_SWIFT_UNAVAILABLE("ObjCDynamicPropertyAttributes is unavailable in Swift. Define dynamic property's implementation in Objective-C instead.");

/// Makes a dynamic property attributes.
///
/// `(_OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_NONE, ##__VA_ARGS__)` is a trick.
///
/// `20`, which `_OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_NONE` stands for, is
/// metamacros's the largest argument number and `##__VA__ARGS__` eliminates
/// itself when `__VA__ARGS__` has nothing.
///
/// So this means to resolve `_OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_NONE` when there
/// is no coming arguments.
#define ObjCDynamicPropertyAttributesMake(...) \
    metamacro_foreach_concat(,,_ObjCDynamicPropertyAttributeOptions(_OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_NONE, ##__VA_ARGS__))

FOUNDATION_EXTERN NSString * NSStringFromObjCDynamicPropertyAttributes(ObjCDynamicPropertyAttributes attributes)
NS_SWIFT_UNAVAILABLE("NSStringFromObjCDynamicPropertyAttributes is unavailable in Swift. Define dynamic property's implementation in Objective-C instead.");

#pragma mark - Defining Dynamic Property Implementation

#define COPY       _OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_COPY
#define RETAIN     _OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_RETAIN
#define NONATOMIC  _OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_NONATOMIC
#define WEAK       _OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_WEAK

#if DEBUG // With debug info
/// Defines a global dynamic property getter. Does nothing when there is an
/// existed one with specified return type and property attributes.
#define ObjCDynamicPropertyGetter(RETURN_TYPE, ...) \
    _OBJCDD_KEYWORD_FILE_SCOPE \
        static _ObjCDynamicPropertyGetter(RETURN_TYPE); \
        _OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY \
        static void metamacro_concat(objcdd_add_dynamic_property_getter, __LINE__)() { \
            ObjCDynamicPropertyAttributes attributes = ObjCDynamicPropertyAttributesMake(__VA_ARGS__); \
            ObjCDynamicPropertySynthesizerAddGetterWithDebugInfo((IMP)&_ObjCDynamicPropertyGetterName, @encode(RETURN_TYPE), attributes, metamacro_stringify(RETURN_TYPE), __FILE__, __LINE__); \
        } \
        _ObjCDynamicPropertyGetter(RETURN_TYPE)

/// Defines a global dynamic property setter. Does nothing when there is an
/// existed one with specified return type and property attributes.
#define ObjCDynamicPropertySetter(TYPE, ...) \
    _OBJCDD_KEYWORD_FILE_SCOPE \
        static _ObjCDynamicPropertySetter(TYPE); \
        _OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY \
        static void metamacro_concat(objcdd_add_dynamic_property_setter, __LINE__)() {\
            ObjCDynamicPropertyAttributes attributes = ObjCDynamicPropertyAttributesMake(__VA_ARGS__); \
            ObjCDynamicPropertySynthesizerAddSetterWithDebugInfo((IMP)&_ObjCDynamicPropertySetterName, @encode(TYPE), attributes, metamacro_stringify(TYPE), __FILE__, __LINE__); \
        } \
        _ObjCDynamicPropertySetter(TYPE)
#else // Without debug info
/// Defines a global dynamic property getter. Does nothing when there is an
/// existed one with specified return type and property attributes.
#define ObjCDynamicPropertyGetter(RETURN_TYPE, ...) \
    _OBJCDD_KEYWORD_FILE_SCOPE \
        static _ObjCDynamicPropertyGetter(RETURN_TYPE); \
        _OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY \
        static void metamacro_concat(objcdd_add_dynamic_property_getter, __LINE__)() { \
            ObjCDynamicPropertyAttributes attributes = ObjCDynamicPropertyAttributesMake(__VA_ARGS__); \
            ObjCDynamicPropertySynthesizerAddGetter((IMP)&_ObjCDynamicPropertyGetterName, @encode(RETURN_TYPE), attributes); \
        } \
        _ObjCDynamicPropertyGetter(RETURN_TYPE)

/// Defines a global dynamic property setter. Does nothing when there is an
/// existed one with specified return type and property attributes.
#define ObjCDynamicPropertySetter(TYPE, ...) \
    _OBJCDD_KEYWORD_FILE_SCOPE \
        static _ObjCDynamicPropertySetter(TYPE); \
        _OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY \
        static void metamacro_concat(objcdd_add_dynamic_property_setter, __LINE__)() {\
            ObjCDynamicPropertyAttributes attributes = ObjCDynamicPropertyAttributesMake(__VA_ARGS__); \
            ObjCDynamicPropertySynthesizerAddSetter((IMP)&_ObjCDynamicPropertySetterName, @encode(TYPE), attributes); \
        } \
        _ObjCDynamicPropertySetter(TYPE)
#endif

/// Defines a class specific dynamic property getter. Always replace the
/// originally one whenever whether is an existed one with specified return type
/// and property attributes.
#define ObjCDynamicPropertyClassSpecificGetter(CLASS, RETURN_TYPE, ...) \
    _OBJCDD_KEYWORD_FILE_SCOPE \
        static _ObjCDynamicPropertyClassSpecificGetter(RETURN_TYPE, CLASS); \
        _OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY \
        static void _ObjCDynamicPropertySymbolSpecificFunctionName(objcdd_add_class_specific_dynamic_property_getter, CLASS)() { \
            ObjCDynamicPropertyAttributes attributes = ObjCDynamicPropertyAttributesMake(__VA_ARGS__); \
            ObjCDynamicPropertySynthesizerSetClassSpecificGetter(CLASS, (IMP)&_ObjCDynamicPropertyClassSpecificGetterName(CLASS), @encode(RETURN_TYPE), attributes); \
        } \
        _ObjCDynamicPropertyClassSpecificGetter(RETURN_TYPE, CLASS)

/// Defines a class specific dynamic property setter. Always replace the
/// originally one whenever whether is an existed one with specified return type
/// and property attributes.
#define ObjCDynamicPropertyClassSpecificSetter(CLASS, TYPE, ...) \
    _OBJCDD_KEYWORD_FILE_SCOPE \
        static _ObjCDynamicPropertyClassSpecificSetter(CLASS, TYPE); \
        _OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY \
        static void _ObjCDynamicPropertySymbolSpecificFunctionName(objcdd_add_class_specific_dynamic_property_setter, CLASS)() { \
            ObjCDynamicPropertyAttributes attributes = ObjCDynamicPropertyAttributesMake(__VA_ARGS__); \
            ObjCDynamicPropertySynthesizerSetClassSpecificSetter((IMP)&_ObjCDynamicPropertyClassSpecificSetterName(CLASS), @encode(TYPE), attributes); \
        } \
        _ObjCDynamicPropertyClassSpecificSetter(CLASS, TYPE)

/// Defines a protocol specific dynamic property getter. Always replace the
/// originally one whenever whether is an existed one with specified return type
/// and property attributes.
#define ObjCDynamicPropertyProtocolSpecificGetter(PROTOCOL, RETURN_TYPE, ...) \
    _OBJCDD_KEYWORD_FILE_SCOPE \
        static _ObjCDynamicPropertyProtocolSpecificGetter(RETURN_TYPE, PROTOCOL); \
        _OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY \
        static void _ObjCDynamicPropertySymbolSpecificFunctionName(objcdd_add_protocol_specific_dynamic_property_getter, PROTOCOL)() { \
            ObjCDynamicPropertyAttributes attributes = ObjCDynamicPropertyAttributesMake(__VA_ARGS__); \
            ObjCDynamicPropertySynthesizerSetProtocolSpecificGetter(@protocol(PROTOCOL), (IMP)&_ObjCDynamicPropertyProtocolSpecificGetterName(PROTOCOL), @encode(RETURN_TYPE), attributes); \
        } \
        _ObjCDynamicPropertyProtocolSpecificGetter(RETURN_TYPE, PROTOCOL)

/// Defines a protocol specific dynamic property setter. Always replace the
/// originally one whenever whether is an existed one with specified return type
/// and property attributes.
#define ObjCDynamicPropertyProtocolSpecificSetter(PROTOCOL, TYPE, ...) \
    _OBJCDD_KEYWORD_FILE_SCOPE \
        static _ObjCDynamicPropertyProtocolSpecificSetter(PROTOCOL, TYPE); \
        _OBJCDD_MODULE_CONSTRUCTOR_HIGH_PRIORITY \
        static void _ObjCDynamicPropertySymbolSpecificFunctionName(objcdd_add_protocol_specific_dynamic_property_setter, PROTOCOL)() { \
            ObjCDynamicPropertyAttributes attributes = ObjCDynamicPropertyAttributesMake(__VA_ARGS__); \
            ObjCDynamicPropertySynthesizerSetProtocolSpecificSetter(@protocol(PROTOCOL), (IMP)&_ObjCDynamicPropertyProtocolSpecificSetterName(PROTOCOL), @encode(TYPE), attributes); \
        } \
        _ObjCDynamicPropertyProtocolSpecificSetter(PROTOCOL, TYPE)

/// Gets the property name in dynamic property accessor's implementation
///
/// - Notes:
/// Only works in dynamic property accessor's implementation.
#define _prop ObjCDynamicPropertySynthesizerGetPropertyNameForSelectorWithClass(_cmd, [self class])

/// Adds a global dynamic property getter implementation.
///
/// Returns NO when there is an existed one. The adding operation is ommited at
/// the same time.
FOUNDATION_EXTERN BOOL ObjCDynamicPropertySynthesizerAddGetter(IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attributes)
NS_SWIFT_UNAVAILABLE("ObjCDynamicPropertySynthesizerAddGetter is unavailable in Swift. Define dynamic property's implementation in Objective-C instead.");

/// Adds a global dynamic property setter implementation.
///
/// Returns NO when there is an existed one. The adding operation is ommited at
/// the same time.
FOUNDATION_EXTERN BOOL ObjCDynamicPropertySynthesizerAddSetter(IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attributes)
NS_SWIFT_UNAVAILABLE("ObjCDynamicPropertySynthesizerAddSetter is unavailable in Swift. Define dynamic property's implementation in Objective-C instead.");

/// Sets a class specific dynamic property getter implementation.
FOUNDATION_EXTERN void ObjCDynamicPropertySynthesizerSetClassSpecificGetter(Class cls, IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attributes)
NS_SWIFT_UNAVAILABLE("ObjCDynamicPropertySynthesizerSetClassSpecificGetter is unavailable in Swift. Define dynamic property's implementation in Objective-C instead.");

/// Sets a class specific dynamic property setter implementation.
FOUNDATION_EXTERN void ObjCDynamicPropertySynthesizerSetClassSpecificSetter(Class cls, IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attributes)
NS_SWIFT_UNAVAILABLE("ObjCDynamicPropertySynthesizerSetClassSpecificSetter is unavailable in Swift. Define dynamic property's implementation in Objective-C instead.");

/// Sets a protocol specific dynamic property getter implementation.
FOUNDATION_EXTERN void ObjCDynamicPropertySynthesizerSetProtocolSpecificGetter(Protocol * protocol, IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attributes)
NS_SWIFT_UNAVAILABLE("ObjCDynamicPropertySynthesizerSetProtocolSpecificGetter is unavailable in Swift. Define dynamic property's implementation in Objective-C instead.");

/// Sets a protocol specific dynamic property setter implementation.
FOUNDATION_EXTERN void ObjCDynamicPropertySynthesizerSetProtocolSpecificSetter(Protocol * protocol, IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attributes)
NS_SWIFT_UNAVAILABLE("ObjCDynamicPropertySynthesizerSetProtocolSpecificSetter is unavailable in Swift. Define dynamic property's implementation in Objective-C instead.");

/// Gets the dynamic property's name with its class and selector(whenever the
/// setter or getter's).
///
/// wrapper the the internal raw C string.
FOUNDATION_EXTERN NSString * ObjCDynamicPropertySynthesizerGetPropertyNameForSelectorWithClass(SEL selector, Class cls)
NS_SWIFT_UNAVAILABLE("ObjCDynamicPropertySynthesizerGetPropertyNameForSelectorWithClass is unavailable in Swift. Define dynamic property's implementation in Objective-C instead.");

#pragma mark - Implementation Details
/* You shall not write code depends on following things. */

#define _OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_COPY       0
#define _OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_RETAIN     1
#define _OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_NONATOMIC  2
#define _OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_WEAK       3
#define _OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_NONE       20

/// Resolves a property attribute option from an argument.
///
/// A simple simulation to the following decision tree:
///
/// ```
///     NOTHING
///   /         \
/// COPY      NOT COPY
///          /        \
///       RETAIN  NOT RETAIN
///              /          \
///         NONATOMIC  NOT NOATOMIC
///                   /            \
///                 WEAK        NOT WEAK
///                                     \
///                                    NONE
///
/// ```
#define _ObjCDynamicPropertyAttributeOption(INDEX, ARG) \
    metamacro_if_eq(COPY, ARG)(ObjCDynamicPropertyAttributeCopy)( \
        metamacro_if_eq(RETAIN, ARG)(ObjCDynamicPropertyAttributeRetain)( \
            metamacro_if_eq(NONATOMIC, ARG)(ObjCDynamicPropertyAttributeNonatomic)( \
                metamacro_if_eq(WEAK, ARG)(ObjCDynamicPropertyAttributeWeak)( \
                    metamacro_if_eq(_OBJC_DYNAMIC_PROPERTY_ATTRIBUTE_NONE, ARG)(ObjCDynamicPropertyAttributeNone)( \
                    ) \
                ) \
            ) \
        ) \
    )

/// Resolves property attributes options from arguments and concatenates them
/// with a "|" operator.
#define _ObjCDynamicPropertyAttributeOptions(...) \
    metamacro_foreach(_ObjCDynamicPropertyAttributeOption,|, __VA_ARGS__)

/// Generates a dynamic property utility function name like A_B_LineNumber.
#define _ObjCDynamicPropertySymbolSpecificFunctionName(TITLE, SYMBOL) \
    metamacro_concat(\
        metamacro_concat(\
            metamacro_concat(\
                TITLE,\
                SYMBOL\
            ),\
            _\
        ),\
        __LINE__\
    )

#define _ObjCDynamicPropertyGetterName metamacro_concat(objcdd_dynamic_property_getter_, __LINE__)
#define _ObjCDynamicPropertySetterName metamacro_concat(objcdd_dynamic_property_setter_, __LINE__)

#define _ObjCDynamicPropertyGetter(RETURN_TYPE) RETURN_TYPE _ObjCDynamicPropertyGetterName(id<ObjCDynamicPropertySynthesizing> self, SEL _cmd)
#define _ObjCDynamicPropertySetter(TYPE) void _ObjCDynamicPropertySetterName(id<ObjCDynamicPropertySynthesizing> self, SEL _cmd, TYPE newValue)

#define _ObjCDynamicPropertyClassSpecificGetterName(CLASS) _ObjCDynamicPropertySymbolSpecificFunctionName(objcdd_class_specific_dynamic_property_getter, CLASS)
#define _ObjCDynamicPropertyClassSpecificSetterName(CLASS) _ObjCDynamicPropertySymbolSpecificFunctionName(objcdd_class_specific_dynamic_property_setter, CLASS)

#define _ObjCDynamicPropertyClassSpecificGetter(RETURN_TYPE, CLASS) RETURN_TYPE _ObjCDynamicPropertyClassSpecificGetterName(CLASS)(CLASS self, SEL _cmd)
#define _ObjCDynamicPropertyClassSpecificSetter(CLASS, TYPE) void _ObjCDynamicPropertyClassSpecificSetterName(CLASS)(CLASS self, SEL _cmd, TYPE newValue)

#define _ObjCDynamicPropertyProtocolSpecificGetterName(PROTOCOL) _ObjCDynamicPropertySymbolSpecificFunctionName(objcdd_protocol_specific_dynamic_property_getter, PROTOCOL)
#define _ObjCDynamicPropertyProtocolSpecificSetterName(PROTOCOL) _ObjCDynamicPropertySymbolSpecificFunctionName(objcdd_protocol_specific_dynamic_property_setter, PROTOCOL)

#define _ObjCDynamicPropertyProtocolSpecificGetter(RETURN_TYPE, PROTOCOL) RETURN_TYPE _ObjCDynamicPropertyProtocolSpecificGetterName(PROTOCOL)(id<PROTOCOL> self, SEL _cmd)
#define _ObjCDynamicPropertyProtocolSpecificSetter(PROTOCOL, TYPE) void _ObjCDynamicPropertyProtocolSpecificSetterName(PROTOCOL)(id<PROTOCOL> self, SEL _cmd, TYPE newValue)

#if DEBUG
/// Adds a global dynamic property getter implementation and logs failure info
/// if it is failed when built with `DEBUG` configuration.
__attribute__((visibility("hidden")))
FOUNDATION_EXTERN void ObjCDynamicPropertySynthesizerAddGetterWithDebugInfo(
    IMP imp,
    const char * typeEncoding,
    ObjCDynamicPropertyAttributes attributes,
    const char * typeName,
    const char * file,
    int line
)
NS_SWIFT_UNAVAILABLE("_ObjCDynamicPropertySynthesizerAddGetter is unavailable in Swift, define dynamic property's implementation with Objective-C instead.");

/// Adds a global dynamic property setter implementation and logs failure info
/// if it is failed when built with `DEBUG` configuration.
__attribute__((visibility("hidden")))
FOUNDATION_EXTERN void ObjCDynamicPropertySynthesizerAddSetterWithDebugInfo(
    IMP imp,
    const char * typeEncoding,
    ObjCDynamicPropertyAttributes attributes,
    const char * typeName,
    const char * file,
    int line
)
NS_SWIFT_UNAVAILABLE("_ObjCDynamicPropertySynthesizerAddSetter is unavailable in Swift, define dynamic property's implementation with Objective-C instead.");
#endif

NS_ASSUME_NONNULL_END

#endif /* ObjCDynamicPropertySynthesizer_h */
