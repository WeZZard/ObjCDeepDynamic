//
//  ObjCDynamicPropertySynthesizer.m
//  ObjCDeepDynamic
//
//  Created by WeZZard on 24/12/2016.
//
//

#include <CoreFoundation/CoreFoundation.h>

#include <algorithm>
#include <iostream>

#include "ObjCDynamicPropertySynthesizer.h"
#include "ObjCDynamicPropertySynthesizer+Internal.h"

static NSString const * kObjCDynamicPropertyAttributesDescriptionEmpty = @"";

namespace objcdd {
    struct PropertyDescription;
    struct ImplementationStorage;
    struct AccessorDescription;
}

static const ObjCDynamicPropertyAttributes ObjCDynamicPropertyAttributesMakeWithAccessorDescription(const objcdd::AccessorDescription& accessor_description);

static const std::string object_type_encoding_prefix = "@";

#pragma mark - C Interface Bindings
NSString * ObjCDynamicPropertySynthesizerGetPropertyNameForSelectorWithClass(SEL selector, Class cls) {
    auto property_name = objcdd::ObjCDynamicPropertySynthesizer::shared().getPropertyName(cls, selector);
    if (property_name) {
        return [NSString stringWithCString:property_name encoding:NSUTF8StringEncoding];
    }
    return nil;
}

BOOL ObjCDynamicPropertySynthesizerAddGetter(IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attrs) {
    return objcdd::ObjCDynamicPropertySynthesizer::shared().addImplementation(imp, objcdd::AccessorKind::getter, typeEncoding, attrs);
}

BOOL ObjCDynamicPropertySynthesizerAddSetter(IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attrs) {
    return objcdd::ObjCDynamicPropertySynthesizer::shared().addImplementation(imp, objcdd::AccessorKind::setter, typeEncoding, attrs);
}

#if DEBUG
void ObjCDynamicPropertySynthesizerAddGetterWithDebugInfo(IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attributes, const char * typeName, const char * file, int line) {
    if (!ObjCDynamicPropertySynthesizerAddGetter(imp, typeEncoding, attributes)) {
        NSMutableArray<NSString *> * implementationDescriptions = [[NSMutableArray<NSString *> alloc] init];
        [implementationDescriptions addObject:[NSString stringWithUTF8String:typeName]];
        if (attributes != ObjCDynamicPropertyAttributeNone) {
            [implementationDescriptions addObject:NSStringFromObjCDynamicPropertyAttributes(attributes)];
        }
        NSString * implementationDescription = [implementationDescriptions componentsJoinedByString:@" "];
        NSLog(@"Dynamic property getter implementation for \"%@\" was omitted because there is an existed one. SOURCE FILE: %s LINE: %d", implementationDescription, file, line);
    }
    ObjCDynamicPropertySynthesizerAddGetter(imp, typeEncoding, attributes);
}

void ObjCDynamicPropertySynthesizerAddSetterWithDebugInfo(IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attributes, const char * typeName, const char * file, int line) {
    if (!ObjCDynamicPropertySynthesizerAddSetter(imp, typeEncoding, attributes)) {
        NSMutableArray<NSString *> * implementationDescriptions = [[NSMutableArray<NSString *> alloc] init];
        [implementationDescriptions addObject:[NSString stringWithUTF8String:typeName]];
        if (attributes != ObjCDynamicPropertyAttributeNone) {
            [implementationDescriptions addObject:NSStringFromObjCDynamicPropertyAttributes(attributes)];
        }
        NSString * implementationDescription = [implementationDescriptions componentsJoinedByString:@" "];
        NSLog(@"Dynamic property setter implementation for \"%@\" was omitted because there is an existed one. SOURCE FILE: %s LINE: %d", implementationDescription, file, line);
    }
    ObjCDynamicPropertySynthesizerAddSetter(imp, typeEncoding, attributes);
}
#endif

void ObjCDynamicPropertySynthesizerSetClassSpecificGetter(Class cls, IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attrs) {
    objcdd::ObjCDynamicPropertySynthesizer::shared().setClassSpecificImplementation(cls, imp, objcdd::AccessorKind::getter, typeEncoding, attrs);
}

void ObjCDynamicPropertySynthesizerSetClassSpecificSetter(Class cls, IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attrs) {
    objcdd::ObjCDynamicPropertySynthesizer::shared().setClassSpecificImplementation(cls, imp, objcdd::AccessorKind::setter, typeEncoding, attrs);
}

void ObjCDynamicPropertySynthesizerSetProtocolSpecificGetter(Protocol * protocol, IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attributes) {
    objcdd::ObjCDynamicPropertySynthesizer::shared().setProtocolSpecificImplementation(protocol, imp, objcdd::AccessorKind::getter, typeEncoding, attributes);
}

void ObjCDynamicPropertySynthesizerSetProtocolSpecificSetter(Protocol * protocol, IMP imp, const char * typeEncoding, ObjCDynamicPropertyAttributes attributes) {
    objcdd::ObjCDynamicPropertySynthesizer::shared().setProtocolSpecificImplementation(protocol, imp, objcdd::AccessorKind::setter, typeEncoding, attributes);
}

NSString * NSStringFromObjCDynamicPropertyAttributes(ObjCDynamicPropertyAttributes attributes) {
    NSMutableArray<NSString *> * attributeDescriptions = [[NSMutableArray<NSString *> alloc] init];
    if ((attributes & ObjCDynamicPropertyAttributeCopy) != 0) {
        [attributeDescriptions addObject:@"copy"];
    }
    if ((attributes & ObjCDynamicPropertyAttributeRetain) != 0) {
        [attributeDescriptions addObject:@"retain"];
    }
    if ((attributes & ObjCDynamicPropertyAttributeNonatomic) != 0) {
        [attributeDescriptions addObject:@"nonatomic"];
    }
    if ((attributes & ObjCDynamicPropertyAttributeWeak) != 0) {
        [attributeDescriptions addObject:@"weak"];
    }
    if ([attributeDescriptions count] > 0) {
        return [attributeDescriptions componentsJoinedByString:@", "];
    } else {
        return (NSString *)kObjCDynamicPropertyAttributesDescriptionEmpty;
    }
}

namespace objcdd {
#pragma mark - Interfaces
#pragma mark - PropertyDescription
    struct PropertyDescription {
    private:
        const char * name_; // Name is kept in ObjC runtime.
        
        std::unique_ptr<std::string> type_encoding_;
        
        bool is_readonly_;
        
        bool is_copy_;
        
        bool is_retain_;
        
        bool is_nonatomic_;
        
        SEL getter_selector_;
        
        SEL setter_selector_;
        
        bool is_dynamic_;
        
        bool is_weak_;
        
        bool is_garbage_collection_eligible_;
        
        std::unique_ptr<std::string> type_encoding_old_;
        
        std::unique_ptr<std::string> ivar_;
        
    public:
        const char * name() const;
        
        const std::string& typeEncoding() const;
        
        bool isReadonly() const;
        
        bool isCopy() const;
        
        bool isRetain() const;
        
        bool isNonatomic() const;
        
        SEL getterSelector() const;
        
        SEL setterSelector() const;
        
        bool isDynamic() const;
        
        bool isWeak() const;
        
        bool isGarbageCollectionEligible() const;
        
        const std::string& typeEncodingOld() const;
        
        const std::string& ivar() const;
        
        static PropertyDescription makePropertyDescription(const objc_property_t property);
        
        static PropertyDescription makePropertyDescription(const char * name, const objc_property_attribute_t * attributes, const unsigned int attribute_count);
        
    private:
        PropertyDescription(
            const char * name,
            std::unique_ptr<std::string>&& type_encoding,
            const bool is_readonly,
            const bool is_copy,
            const bool is_retain,
            const bool is_nonatomic,
            const SEL getter_selector,
            const SEL setter_selector,
            const bool is_dynamic,
            const bool is_weak,
            const bool is_garbage_collection_eligible,
            std::unique_ptr<std::string>&& type_encoding_old,
            std::unique_ptr<std::string>&& ivar
        );
        
        static std::unique_ptr<std::string> _makePropertyDefaultSetterName(const char * raw_property_name);
    };
    
#pragma mark - AccessorDescription
    struct AccessorDescription {
    private:
        AccessorKind kind_;
        
        const char * name_;
        
        bool is_copy_;
        bool is_retain_;
        bool is_nonatomic_;
        bool is_weak_;
        
        SEL selector_;
        
        std::unique_ptr<std::string> property_type_encoding_;
        
        // type encoding for the accessor, not the property
        std::unique_ptr<std::string> accessor_type_encoding_;
        
    public:
        AccessorKind kind() const;
        
        const char * name() const;
        
        bool isCopy() const;
        bool isRetain() const;
        bool isNonatomic() const;
        bool isWeak() const;
        
        SEL selector() const;
        
        const std::string& propertyTypeEncoding() const;
        
        const std::string& accessorTypeEncoding() const;
        
#if DEBUG
        const std::string selectorName() const;
        
        const std::string propertyName() const;
#endif
        
        static AccessorDescription makeAccessorDescription(const AccessorKind kind, const PropertyDescription& property_description);
        
    private:
        AccessorDescription(
            const AccessorKind kind,
            const char * name,
            const bool is_copy,
            const bool is_retain,
            const bool is_nonatomic,
            const bool is_weak,
            const SEL selector,
            std::unique_ptr<std::string>&& property_type_encoding,
            std::unique_ptr<std::string>&& accessor_type_encoding
        );
    };
    
#pragma mark - ImplementationStorage
    class ImplementationStorage {
    public:
        bool addImplementation(const IMP imp, const AccessorKind kind, const char * type_encoding, const ObjCDynamicPropertyAttributes attributes);
        
        void setImplementation(const IMP imp, const AccessorKind kind, const char * type_encoding, const ObjCDynamicPropertyAttributes attributes);
        
        IMP getImplementation(const AccessorDescription& accessor_description) const;
        
        ImplementationStorage();
        
    private:
        static std::unique_ptr<std::string> _makeImplemenationIdentifier(const char *type_encoding, ObjCDynamicPropertyAttributes attributes);
        
        std::unique_ptr<std::unordered_map<std::string, const IMP>> getter_implementations_;
        std::unique_ptr<std::unordered_map<std::string, const IMP>> setter_implementations_;
        
    };
    
#pragma mark - ProtocolDescription
    class ProtocolDescription {
    public:
        ProtocolDescription(const Protocol * protocol);
        
        const std::string& name() const { return * name_; }
        
        /* Gets protocol specific implementation, searches parents */
        IMP getImplementation(const AccessorDescription& accessor_description) const;
        
        /* Sets protocol specific implementation */
        void setImplementation(IMP imp, AccessorKind kind, const char * type_encoding, ObjCDynamicPropertyAttributes attributes);
        
        const ProtocolDescription * parent() const;
        
        void setParent(const ProtocolDescription& parent);
        
        bool isParent(const ProtocolDescription& parent) const;
        
        bool hasParent() const;
        
    private:
        ImplementationStorage& _ImplementationStorage();
        
        std::unique_ptr<std::string> name_;
        
        std::unique_ptr<ImplementationStorage> dedicated_implementation_center_;
        
        // An unowed relationship to the parent(a reference to the unique pointer)
        const ProtocolDescription * parent_;
    };
    
#pragma mark - ClassDescription
    class ClassDescription {
    public:
        ClassDescription(ObjCDynamicPropertySynthesizer& dynamic_property_synthesizer, const Class cls);
        
        bool isPrepared() const { return is_prepared_; }
        
        void appendProperty(const char * name, const objc_property_attribute_t * attributes, unsigned int attribute_count);
        
        void appendProtocol(const Protocol * protocol);
        
        /* Gets accessor description, searches parents */
        const AccessorDescription * getAccessorDescriptionForSelector(const SEL selector) const;
        
        /* Gets accessor description, searches parents */
        const AccessorDescription * getAccessorDescriptionForKey(const NSString * key) const;
        
        const std::string& name() const { return * name_; }
        
        /* Gets class specific implementation, searches parents */
        IMP getImplementation(const AccessorDescription& accessor_description) const;
        
        /* Sets class specific implementation */
        void setImplementation(IMP imp, AccessorKind kind, const char * type_encoding, ObjCDynamicPropertyAttributes attributes);
        
        const ClassDescription * parent() const;
        
        void setParent(const ClassDescription& class_description);
        
        bool isParent(const ClassDescription& class_description) const;
        
        bool hasParent() const;
        
        void prepareIfNeeded();
    private:
        
        ImplementationStorage& _ImplementationStorage();
        
        IMP _getImplementationInClassHierarchy(const AccessorDescription& accessor_description) const;
        
        const AccessorDescription * _getAccessorDescriptionInClassHierarchy(const SEL selector) const;
        
        const AccessorDescription * _getAccessorDescriptionInClass(const SEL selector) const;
        
        bool _bookkeepPropertyDescriptionIfNeeded(const PropertyDescription& property_description);
        
        bool _shouldBookkeepPropertyDescription(const PropertyDescription& property_description) const;
        
        void _bookkeepPropertyDescription(const PropertyDescription& property_description);
        
        bool _bookkeepProtocolDescriptionIfNeeded(const ProtocolDescription& property_description);
        
        void _bookkeepProtocolDescription(const ProtocolDescription& protocol_description);
        
        std::unique_ptr<std::string> name_;
        
        bool is_prepared_;
        
        // Properties
        std::unique_ptr<std::vector<std::unique_ptr<PropertyDescription>>> processed_property_descriptions_;
        
        std::unique_ptr<std::vector<std::unique_ptr<PropertyDescription>>> pending_property_descriptios_;
        
        // Protocols
        std::unique_ptr<std::vector<std::reference_wrapper<const ProtocolDescription>>> processed_protocol_descriptions_;
        
        std::unique_ptr<std::vector<std::reference_wrapper<const ProtocolDescription>>> pending_protocol_descriptions_;
        
        /* Stores property accessor description.
         * The key is the `getter_selector` or `setter_selector` member in `AccessorDescription`.
         * The key is reference to get avoid of unneccessary ownership consideration.
         */
        std::unique_ptr<std::unordered_map<const void *, AccessorDescription>> accessor_descriptions_;
        
        std::unique_ptr<ImplementationStorage> dedicated_implementation_center_;
        
        // An unowed relationship to the parent
        const ClassDescription * parent_;
        
        ObjCDynamicPropertySynthesizer& dynamic_property_synthesizer_;
    };
    
#pragma mark - Implementations
    
#pragma mark - PropertyDescription
    PropertyDescription::PropertyDescription(
        const char * name,
        std::unique_ptr<std::string>&& type_encoding,
        const bool is_readonly,
        const bool is_copy,
        const bool is_retain,
        const bool is_nonatomic,
        const SEL getter_selector,
        const SEL setter_selector,
        const bool is_dynamic,
        const bool is_weak,
        const bool is_garbage_collection_eligible,
        std::unique_ptr<std::string>&& type_encoding_old,
        std::unique_ptr<std::string>&& ivar
    ):
        name_ (name),
        type_encoding_ (std::move(type_encoding)),
        is_readonly_ (is_readonly),
        is_copy_ (is_copy),
        is_retain_ (is_retain),
        is_nonatomic_ (is_nonatomic),
        getter_selector_ (getter_selector),
        setter_selector_ (setter_selector),
        is_dynamic_ (is_dynamic),
        is_weak_ (is_weak),
        is_garbage_collection_eligible_ (is_garbage_collection_eligible),
        type_encoding_old_ (std::move(type_encoding_old)),
        ivar_ (std::move(ivar))
    {}
    
    const char * PropertyDescription::name() const { return name_; }
    
    const std::string& PropertyDescription::typeEncoding() const {
        return * type_encoding_;
    }
    
    bool PropertyDescription::isReadonly() const { return is_readonly_; }
    
    bool PropertyDescription::isCopy() const { return is_copy_; }
    
    bool PropertyDescription::isRetain() const { return is_retain_; }
    
    bool PropertyDescription::isNonatomic() const { return is_nonatomic_; }
    
    SEL PropertyDescription::getterSelector() const { return getter_selector_; }
    
    SEL PropertyDescription::setterSelector() const { return setter_selector_; }
    
    bool PropertyDescription::isDynamic() const { return is_dynamic_; }
    
    bool PropertyDescription::isWeak() const { return is_weak_; }
    
    bool PropertyDescription::isGarbageCollectionEligible() const {
        return is_garbage_collection_eligible_;
    }
    
    const std::string& PropertyDescription::typeEncodingOld() const {
        return * type_encoding_old_;
    }
    
    const std::string& PropertyDescription::ivar() const { return * ivar_; }
    
    PropertyDescription PropertyDescription::makePropertyDescription(const char * raw_name, const objc_property_attribute_t * attributes, const unsigned int attribute_count) {
        auto getter_name = raw_name;
        auto setter_name = _makePropertyDefaultSetterName(raw_name);
        
        auto name = raw_name;
        std::unique_ptr<std::string> type_encoding;
        bool is_readonly = false;
        bool is_copy = false;
        bool is_retain = false;
        bool is_nonatomic = false;
        SEL getter_selector = nullptr;
        SEL setter_selector = nullptr;
        bool is_dynamic = false;
        bool is_weak = false;
        bool is_garbage_collection_eligible = false;
        std::unique_ptr<std::string> type_encoding_old;
        std::unique_ptr<std::string> ivar;
        
        for (unsigned int index = 0; index < attribute_count; index ++) {
            auto attribute = attributes[index];
            auto attribute_name = (* attribute.name);
            switch (attribute_name) {
                case 'R':
                    is_readonly = true;
                    break;
                case 'C':
                    is_copy = true;
                    break;
                case '&':
                    is_retain = true;
                    break;
                case 'G':
                    getter_name = attribute.value;
                    break;
                case 'S':
                    setter_name.reset(new std::string(attribute.value));
                    break;
                case 'D':
                    is_dynamic = true;
                    break;
                case 'W':
                    is_weak = true;
                    break;
                case 'P':
                    is_garbage_collection_eligible = true;
                    break;
                case 't':
                    type_encoding_old = std::make_unique<std::string>(attribute.value);
                    break;
                case 'T':
                    type_encoding = std::make_unique<std::string>(attribute.value);
                    if (type_encoding -> substr(0, 1) == object_type_encoding_prefix) {
                        type_encoding = std::make_unique<std::string>(object_type_encoding_prefix);
                    }
                    break;
                case 'V':
                    ivar = std::make_unique<std::string>(attribute.value);
                    break;
            }
        }
        
        NSString * getterName = [NSString stringWithCString:getter_name encoding:NSUTF8StringEncoding];
        getter_selector = NSSelectorFromString(getterName);
        assert(getter_selector != nullptr);
        
        if (!is_readonly) {
            NSString * setterName = [[NSString alloc] initWithBytesNoCopy:(void *)setter_name -> c_str() length:setter_name -> length() encoding:NSUTF8StringEncoding freeWhenDone:NO];
            setter_selector = NSSelectorFromString(setterName);
            assert(setter_selector != nullptr);
        }
        
        return PropertyDescription(name, std::move(type_encoding), is_readonly, is_copy, is_retain, is_nonatomic, getter_selector, setter_selector, is_dynamic, is_weak, is_garbage_collection_eligible, std::move(type_encoding_old), std::move(ivar));
    }
    
    PropertyDescription PropertyDescription::makePropertyDescription(objc_property_t property) {
        auto raw_name = property_getName(property);
        unsigned int attribute_count = 0;
        auto attributes = property_copyAttributeList(property, &attribute_count);
        
        auto property_description = makePropertyDescription(raw_name, attributes, attribute_count);
        
        if (attributes) {
            free((void *)attributes);
        }
        
        return property_description;
    }
    
    std::unique_ptr<std::string> PropertyDescription::_makePropertyDefaultSetterName(const char *raw_property_name) {
        auto property_name = CFStringCreateWithCString(kCFAllocatorDefault, raw_property_name, kCFStringEncodingUTF8);
        auto property_name_length = CFStringGetLength(property_name);
        
        assert(property_name_length > 0);
        
        auto first_composed_character_range = CFStringGetRangeOfComposedCharactersAtIndex(property_name, 0);
        auto rest_substring_range = CFRangeMake(first_composed_character_range.length, property_name_length - first_composed_character_range.length);
        
        auto first_composed_character = CFStringCreateWithSubstring(kCFAllocatorDefault, property_name, first_composed_character_range);
        auto first_composed_character_uppercased = CFStringCreateMutableCopy(kCFAllocatorDefault, 0, first_composed_character);
        CFStringUppercase(first_composed_character_uppercased, CFLocaleGetSystem());
        
        auto rest_substring = CFStringCreateWithSubstring(kCFAllocatorDefault, property_name, rest_substring_range);
        
        auto default_setter_name_cf = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("set%@%@:"), first_composed_character_uppercased, rest_substring);
        
        const char * default_setter_name_raw = CFStringGetCStringPtr(default_setter_name_cf, kCFStringEncodingUTF8);
        
        auto default_setter_name = std::make_unique<std::string>(default_setter_name_raw);
        
        CFRelease(first_composed_character);
        CFRelease(first_composed_character_uppercased);
        CFRelease(rest_substring);
        CFRelease(default_setter_name_cf);
        CFRelease(property_name);
        
        return default_setter_name;
    }
    
#pragma mark - AccessorDescription
    AccessorKind AccessorDescription::kind() const { return kind_; }
    
    const char * AccessorDescription::name() const { return name_; }
    
    bool AccessorDescription::isCopy() const { return is_copy_; }
    
    bool AccessorDescription::isRetain() const { return is_retain_; }
    
    bool AccessorDescription::isNonatomic() const { return is_nonatomic_; }
    
    bool AccessorDescription::isWeak() const { return is_weak_; }
    
    SEL AccessorDescription::selector() const { return selector_; }
    
    const std::string& AccessorDescription::propertyTypeEncoding() const {
        return * property_type_encoding_;
    }
    
    const std::string& AccessorDescription::accessorTypeEncoding() const {
        return * accessor_type_encoding_;
    }
    
#if DEBUG
    const std::string AccessorDescription::selectorName() const {
        assert (selector_ != nil);
        return std::string(sel_getName(selector_));
    };
    
    const std::string AccessorDescription::propertyName() const {
        assert (name_ != nil);
        return std::string(name_);
    };
#endif
    
    AccessorDescription::AccessorDescription(
        const AccessorKind kind,
        const char * name,
        const bool is_copy,
        const bool is_retain,
        const bool is_nonatomic,
        const bool is_weak,
        const SEL selector,
        std::unique_ptr<std::string>&& property_type_encoding,
        std::unique_ptr<std::string>&& accessor_type_encoding
    ):
        kind_ (kind),
        name_ (name),
        is_copy_ (is_copy),
        is_retain_ (is_retain),
        is_nonatomic_ (is_nonatomic),
        is_weak_ (is_weak),
        selector_ (selector),
        property_type_encoding_ (std::move(property_type_encoding)),
        accessor_type_encoding_ (std::move(accessor_type_encoding))
    {}
    
    AccessorDescription AccessorDescription::makeAccessorDescription(const AccessorKind kind, const PropertyDescription& property_description) {
        auto name = property_description.name();
        
        auto is_copy = property_description.isCopy();
        
        auto is_retain = property_description.isRetain();
        
        auto is_nonatomic = property_description.isNonatomic();
        
        auto is_weak = property_description.isWeak();
        
        SEL selector = nullptr;
        
        switch (kind) {
            case AccessorKind::getter:
                selector = property_description.getterSelector();
                break;
            case AccessorKind::setter:
                selector = property_description.setterSelector();
                break;
        }
        
        auto property_type_encoding = property_description.typeEncoding();
        
        auto accessor_type_encoding = std::unique_ptr<std::string>();
        
        switch (kind) {
            case AccessorKind::getter: {
                auto type_encodings = "@:";
                accessor_type_encoding = std::make_unique<std::string>(type_encodings);
                break;
            }
            case AccessorKind::setter: {
                std::string type_encodings = "@:";
                type_encodings += property_description.typeEncoding();
                accessor_type_encoding = std::make_unique<std::string>(type_encodings);
                break;
            }
        }
        
        return AccessorDescription(kind, name, is_copy, is_retain, is_nonatomic, is_weak, selector, std::make_unique<std::string>(property_type_encoding), std::move(accessor_type_encoding));
    }
    
#pragma mark - ImplementationStorage
    ImplementationStorage::ImplementationStorage():
        getter_implementations_ (std::make_unique<std::unordered_map<std::string, const IMP>>()),
        setter_implementations_ (std::make_unique<std::unordered_map<std::string, const IMP>>())
    { }
    
    bool ImplementationStorage::addImplementation(const IMP imp, const AccessorKind kind, const char *type_encoding, const ObjCDynamicPropertyAttributes attributes) {
        auto identifier = _makeImplemenationIdentifier(type_encoding, attributes);
        
        switch (kind) {
            case AccessorKind::getter:
                if (getter_implementations_ -> find(* identifier) == getter_implementations_ -> cend()) {
                    getter_implementations_ -> emplace(std::move(* identifier), imp);
                    return true;
                }
                return false;
                break;
            case AccessorKind::setter:
                if (setter_implementations_ -> find(* identifier) == setter_implementations_ -> cend()) {
                    setter_implementations_ -> emplace(std::move(* identifier), imp);
                    return true;
                }
                return false;
                break;
        }
    }
    
    void ImplementationStorage::setImplementation(const IMP imp, const AccessorKind kind, const char *type_encoding, const ObjCDynamicPropertyAttributes attributes) {
        auto identifier = _makeImplemenationIdentifier(type_encoding, attributes);
        
        switch (kind) {
            case AccessorKind::getter:
                getter_implementations_ -> emplace(std::move(* identifier), imp);
                break;
            case AccessorKind::setter:
                setter_implementations_ -> emplace(std::move(* identifier), imp);
                break;
        }
    }
    
    IMP ImplementationStorage::getImplementation(const AccessorDescription& accessor_description) const {
        auto property_attributes = ObjCDynamicPropertyAttributesMakeWithAccessorDescription(accessor_description);
        auto type_encoding = accessor_description.propertyTypeEncoding().c_str();
        
        auto identifier = _makeImplemenationIdentifier(type_encoding, property_attributes);
        
        switch (accessor_description.kind()) {
            case AccessorKind::getter: {
                auto matches = getter_implementations_ -> find(* identifier);
                if (matches != getter_implementations_ -> cend()) {
                    return matches -> second;
                }
#if DEBUG
                std::cout << "Missing getter implementation for implementation identifier: \"" << * identifier << "\"" << std::endl;
                for (auto& each : * getter_implementations_) {
                    std::cout << "Existed getter implementation identifier: \"" << each.first << "\"" << std::endl;
                }
#endif
                break;
            }
            case AccessorKind::setter: {
                auto matches = setter_implementations_ -> find(* identifier);
                if (matches != setter_implementations_ -> cend()) {
                    return matches -> second;
                }
#if DEBUG
                std::cout << "Missing setter implementation for implementation identifier: \"" << * identifier << "\"" << std::endl;
                for (auto& each : * setter_implementations_) {
                    std::cout << "Existed setter implementation identifier: \"" << each.first << "\"" << std::endl;
                }
#endif
                break;
            }
        }
        return nullptr;
    }
    
    std::unique_ptr<std::string> ImplementationStorage::_makeImplemenationIdentifier(const char *type_encoding, ObjCDynamicPropertyAttributes attributes) {
        NSCParameterAssert(type_encoding != nullptr);
        
        auto identifier = std::make_unique<std::string>(type_encoding);
        
        if ((attributes & ObjCDynamicPropertyAttributeCopy) != 0) {
            identifier -> append("c");
        }
        if ((attributes & ObjCDynamicPropertyAttributeRetain) != 0) {
            identifier -> append("&");
        }
        if ((attributes & ObjCDynamicPropertyAttributeNonatomic) != 0) {
            identifier -> append("N");
        }
        if ((attributes & ObjCDynamicPropertyAttributeWeak) != 0) {
            identifier -> append("W");
        }
        
        return identifier;
    }
    
#pragma mark - ProtocolDescription - Public
    IMP ProtocolDescription::getImplementation(const AccessorDescription& accessor_description) const {
        if (dedicated_implementation_center_ == nullptr) {
            return nil;
        } else {
            return dedicated_implementation_center_ -> getImplementation(accessor_description);
        }
    }
    
    void ProtocolDescription::setImplementation(const IMP imp, const AccessorKind kind, const char * type_encoding, const ObjCDynamicPropertyAttributes attributes) {
        _ImplementationStorage().setImplementation(imp, kind, type_encoding, attributes);
    }
    
    const ProtocolDescription * ProtocolDescription::parent() const {
        return parent_;
    }
    
    void ProtocolDescription::setParent(const ProtocolDescription& parent) {
        assert(parent_ == nullptr);
        parent_ = &parent;
    }
    
    bool ProtocolDescription::isParent(const ProtocolDescription& parent) const {
        return parent_ == &parent;
    }
    
    bool ProtocolDescription::hasParent() const {
        return parent_ != nullptr;
    }
    
    ProtocolDescription::ProtocolDescription(const Protocol * protocol) {
        auto raw_name = protocol_getName((Protocol *)protocol);
        name_ = std::make_unique<std::string>(raw_name);
        dedicated_implementation_center_ = std::unique_ptr<ImplementationStorage>();
        parent_ = nullptr;
    }
    
    ImplementationStorage& ProtocolDescription::_ImplementationStorage() {
        if (dedicated_implementation_center_ == nullptr) {
            dedicated_implementation_center_.reset(new ImplementationStorage());
        }
        return * dedicated_implementation_center_;
    }
    
#pragma mark - ClassDescription
    ClassDescription::ClassDescription(ObjCDynamicPropertySynthesizer& dynamic_property_synthesizer, const Class cls):
        dynamic_property_synthesizer_ (dynamic_property_synthesizer),
        name_ (std::make_unique<std::string>(class_getName(cls))),
        is_prepared_ (false),
        accessor_descriptions_ (std::make_unique<std::unordered_map<const void *, AccessorDescription>>()),
        pending_property_descriptios_ (std::make_unique<std::vector<std::unique_ptr<PropertyDescription>>>()),
        processed_property_descriptions_ (std::make_unique<std::vector<std::unique_ptr<PropertyDescription>>>()),
        pending_protocol_descriptions_ (std::make_unique<std::vector<std::reference_wrapper<const ProtocolDescription>>>()),
        processed_protocol_descriptions_ (std::make_unique<std::vector<std::reference_wrapper<const ProtocolDescription>>>()),
        dedicated_implementation_center_ (std::unique_ptr<ImplementationStorage>()),
        parent_ (nullptr)
    {
        // Book-keeping properties
        unsigned int property_count = 0;
        auto properties = class_copyPropertyList(cls, &property_count);
        
        if (properties) {
            processed_property_descriptions_ -> reserve(property_count);
            accessor_descriptions_ -> reserve(property_count * 2);
            
            for (unsigned int index = 0; index < property_count; index ++) {
                auto property = properties[index];
                
                auto property_description = std::make_unique<PropertyDescription>(PropertyDescription::makePropertyDescription(property));
                
                _bookkeepPropertyDescriptionIfNeeded(* property_description);
                
                processed_property_descriptions_ -> push_back(std::move(property_description));
            }
            
            free(properties);
        }
        
        // Book-keeping protocols
        unsigned int protocol_count = 0;
        auto protocols = class_copyProtocolList(cls, &protocol_count);
        
        if (protocols) {
            processed_protocol_descriptions_ -> reserve(protocol_count);
            
            for (unsigned int index = 0; index < protocol_count; index ++) {
                auto protocol = protocols[index];
                auto& protocol_description = dynamic_property_synthesizer_.getProtocolDescriptionForProtocol(protocol);
                
                _bookkeepProtocolDescription(protocol_description);
                
                processed_protocol_descriptions_ -> push_back(protocol_description);
            }
            
            free(protocols);
        }
    }
    
    void ClassDescription::appendProperty(const char *name, const objc_property_attribute_t *attributes, unsigned int attribute_count) {
        pending_property_descriptios_ -> push_back(std::make_unique<PropertyDescription>(PropertyDescription::makePropertyDescription(name, attributes, attribute_count)));
    }
    
    void ClassDescription::appendProtocol(const Protocol *protocol) {
        auto& protocol_description = dynamic_property_synthesizer_.getProtocolDescriptionForProtocol(protocol);
        pending_protocol_descriptions_ -> push_back(protocol_description);
    }
    
    const AccessorDescription * ClassDescription::getAccessorDescriptionForSelector(const SEL selector) const {
        return _getAccessorDescriptionInClassHierarchy(selector);
    }
    
    const AccessorDescription * ClassDescription::getAccessorDescriptionForKey(const NSString * key) const {
        return _getAccessorDescriptionInClassHierarchy(NSSelectorFromString(static_cast<NSString *>(key)));
    }
    
    IMP ClassDescription::getImplementation(const AccessorDescription& accessor_description) const {
        IMP implementation = _getImplementationInClassHierarchy(accessor_description);
        
        if (implementation == nullptr) {
            if (hasParent()) {
                return parent() -> _getImplementationInClassHierarchy(accessor_description);
            }
        }
        
        return implementation;
    }
    
    void ClassDescription::setImplementation(const IMP imp, const AccessorKind kind, const char * type_encoding, const ObjCDynamicPropertyAttributes attributes) {
        _ImplementationStorage().setImplementation(imp, kind, type_encoding, attributes);
    }
    
    const ClassDescription * ClassDescription::parent() const {
        return parent_;
    }
    
    void ClassDescription::setParent(const ClassDescription& parent) {
        assert(parent_ == nullptr);
        parent_ = &parent;
    }
    
    bool ClassDescription::isParent(const ClassDescription& parent) const {
        return parent_ == &parent;
    }
    
    bool ClassDescription::hasParent() const {
        return parent_ != nullptr;
    }
    
    void ClassDescription::prepareIfNeeded() {
        if (!(pending_property_descriptios_ -> empty())) {
            
            for (auto& property_description : * pending_property_descriptios_) {
                _bookkeepPropertyDescriptionIfNeeded(* property_description);
            }
            
            processed_protocol_descriptions_ -> insert(processed_protocol_descriptions_ -> cend(), pending_protocol_descriptions_ -> cbegin(), pending_protocol_descriptions_ -> cend());
            
            pending_property_descriptios_ -> clear();
        }
        
        assert(pending_property_descriptios_ -> empty());
    }
    
    ImplementationStorage& ClassDescription::_ImplementationStorage() {
        if (dedicated_implementation_center_ == nullptr) {
            dedicated_implementation_center_.reset(new ImplementationStorage());
        }
        return * dedicated_implementation_center_;
    }
    
    IMP ClassDescription::_getImplementationInClassHierarchy(const AccessorDescription& accessor_description) const {
        // Search class specific implementation
        if (dedicated_implementation_center_ == nullptr) {
            return nil;
        } else {
            auto class_specific_implementation = dedicated_implementation_center_ -> getImplementation(accessor_description);
            if (class_specific_implementation) {
                return class_specific_implementation;
            }
        }
        
        // Search protocol specific implementation
        for (auto& protocol_description : * processed_protocol_descriptions_) {
            auto protocol_specific_implementation = protocol_description.get().getImplementation(accessor_description);
            if (protocol_specific_implementation) {
                return protocol_specific_implementation;
            }
        }
        
        return nil;
    }
    
    const AccessorDescription * ClassDescription::_getAccessorDescriptionInClassHierarchy(const SEL selector) const {
        auto accessor_description = _getAccessorDescriptionInClass(selector);
        
        if (accessor_description == nullptr) {
            if (hasParent()) {
                return parent() -> _getAccessorDescriptionInClassHierarchy(selector);
            }
        }
        
        return accessor_description;
    }
    
    const AccessorDescription * ClassDescription::_getAccessorDescriptionInClass(const SEL selector) const {
        auto matches = accessor_descriptions_ -> find(selector);
        if (matches != accessor_descriptions_ -> cend()) {
            return &(matches -> second);
        }
#if DEBUG
        std::cout << "Missing accessor description for selector: " << selector << std::endl;
        for (auto& each : * accessor_descriptions_) {
            assert(each.second.selector() != nil);
            std::cout << "Existed accessor description selector: -" << each.second.selectorName() << std::endl;
        }
#endif
        return nullptr;
    }
    
    bool ClassDescription::_bookkeepPropertyDescriptionIfNeeded(const PropertyDescription& property_description) {
        if (_shouldBookkeepPropertyDescription(std::move(property_description))) {
            _bookkeepPropertyDescription(std::move(property_description));
            return true;
        }
        return false;
    }
    
    bool ClassDescription::_shouldBookkeepPropertyDescription(const PropertyDescription& property_description) const {
        return property_description.isDynamic();
    }
    
    void ClassDescription::_bookkeepPropertyDescription(const PropertyDescription& property_description) {
        accessor_descriptions_ -> emplace(property_description.getterSelector(), AccessorDescription::makeAccessorDescription(AccessorKind::getter, property_description));
        
        if (!property_description.isReadonly()) {
            accessor_descriptions_ -> emplace(property_description.setterSelector(), AccessorDescription::makeAccessorDescription(AccessorKind::setter, property_description));
        }
    }
    
    bool ClassDescription::_bookkeepProtocolDescriptionIfNeeded(const ProtocolDescription& property_description) {
        return true;
    }
    
    void ClassDescription::_bookkeepProtocolDescription(const ProtocolDescription& protocol_description) {
        
    }
    
    
#pragma mark - ObjCDynamicPropertySynthesizer
#pragma mark Accessing the Shared Instance
    ObjCDynamicPropertySynthesizer& ObjCDynamicPropertySynthesizer::shared() {
        static ObjCDynamicPropertySynthesizer shared_instance;
        return shared_instance;
    }
    
#pragma mark Accessing Dynamic-Property Related Information
    bool ObjCDynamicPropertySynthesizer::isClassPrepared(const Class cls) {
        if (_isClassDescriptionLoadedForClass(cls)) {
            return _getClassDescriptionForClass(cls).isPrepared();
        }
        return false;
    }
    
    bool ObjCDynamicPropertySynthesizer::isDynamicProperty(const Class cls, const NSString * key) {
        auto& class_description = _getClassDescriptionForClass(cls);
        auto accessor_description = class_description.getAccessorDescriptionForKey(key);
        return accessor_description != nullptr;
    }
    
    const char * ObjCDynamicPropertySynthesizer::getPropertyName(const Class cls, const SEL selector) {
        if (_isClassDescriptionLoadedForClass(cls)) {
            auto& class_description = _getClassDescriptionForClass(cls);
            auto accessor_description = class_description.getAccessorDescriptionForSelector(selector);
            return accessor_description -> name();
        }
        return nil;
    }
    
    bool ObjCDynamicPropertySynthesizer::addImplementation(const IMP imp, AccessorKind kind, const char * type_encoding, const ObjCDynamicPropertyAttributes attributes) {
        return implementation_storage_ -> addImplementation(imp, kind, type_encoding, attributes);
    }
    
    void ObjCDynamicPropertySynthesizer::setClassSpecificImplementation(const Class cls, const IMP imp, const AccessorKind kind, const char * type_encoding, const ObjCDynamicPropertyAttributes attributes) {
        auto& class_description = _getClassDescriptionForClass(cls);
        class_description.setImplementation(imp, kind, type_encoding, attributes);
    }
    
    void ObjCDynamicPropertySynthesizer::setProtocolSpecificImplementation(const Protocol * protocol, const IMP imp, const AccessorKind kind, const char * type_encoding, const ObjCDynamicPropertyAttributes attributes) {
        auto& protocol_description = getProtocolDescriptionForProtocol(protocol);
        protocol_description.setImplementation(imp, kind, type_encoding, attributes);
    }
    
#pragma mark Objective-C Class Delegation
    void ObjCDynamicPropertySynthesizer::classDidAddProperty(const Class cls, const char * name, const objc_property_attribute_t * attributes, unsigned int attribute_count) {
        if (_isClassDescriptionLoadedForClass(cls)) {
            _getClassDescriptionForClass(cls).appendProperty(name, attributes, attribute_count);
        }
    }
    
    void ObjCDynamicPropertySynthesizer::classDidAddProtocol(const Class cls, const Protocol * protocol) {
        if (_isClassDescriptionLoadedForClass(cls)) {
            _getClassDescriptionForClass(cls).appendProtocol(protocol);
        }
    }
    
#pragma mark Synthesize Property
    bool ObjCDynamicPropertySynthesizer::synthesizeProperty(const Class cls, const SEL selector) {
        auto& class_description = _getClassDescriptionForClass(cls);
        
        auto accessor_description = class_description.getAccessorDescriptionForSelector(selector);
        
        if (accessor_description) {
            // First, find specific implementation.
            auto specific_implementation = class_description.getImplementation(* accessor_description);
            
            if (specific_implementation != nil) {
                auto types = accessor_description -> accessorTypeEncoding().c_str();
                return class_addMethod(cls, selector, specific_implementation, types);
            }
            
            // Then, find global implementation.
            IMP implementation = implementation_storage_ -> getImplementation(* accessor_description);
            
            if (implementation) {
                auto types = accessor_description -> accessorTypeEncoding().c_str();
                return class_addMethod(cls, selector, implementation, types);
            } else {
#if DEBUG
                if (class_isMetaClass(cls)) {
                    std::cout << "No implementation found for class " << class_description.name() << "'s property: " << accessor_description -> propertyName() << ", which is invoked by accessing selector: +" << sel_getName(selector) << "." << std::endl;
                } else {
                    std::cout << "No implementation found for class " << class_description.name() << "'s property: " << accessor_description -> propertyName() << ", which is invoked by accessing selector: -" << sel_getName(selector) << "." << std::endl;
                }
#endif
            }
            
        } else {
#if DEBUG
            if (class_isMetaClass(cls)) {
                std::cout << "No accessor description found for class " << class_description.name() << "'s selector: +" << sel_getName(selector) << "." << std::endl;
            } else {
                std::cout << "No accessor description found for class " << class_description.name() << "'s selector: -" << sel_getName(selector) << "." << std::endl;
            }
#endif
        }
        return false;
    }
#pragma mark Managing Class Descriptions
    ObjCDynamicPropertySynthesizer::ClassDescriptionUnorderedMap& ObjCDynamicPropertySynthesizer::_classDescriptions() {
        return * class_descriptions_;
    }
    
    ClassDescription& ObjCDynamicPropertySynthesizer::_getClassDescriptionForClass(const __unsafe_unretained Class cls) {
        auto& class_descs = _classDescriptions();
        auto matches = class_descs.find((__bridge const void *)cls);
        if (matches != class_descs.cend()) {
            auto& class_description = matches -> second;
            class_description -> prepareIfNeeded();
            return * class_description;
        } else {
            auto class_description = std::make_unique<ClassDescription>(* this, cls);
            auto emplaced = class_descs.emplace((__bridge const void *)cls, std::move(class_description));
            return * emplaced.first -> second;
        }
    }
    
    bool ObjCDynamicPropertySynthesizer::_isClassDescriptionLoadedForClass(const Class cls) {
        auto& class_desc = _classDescriptions();
        auto matches = class_desc.find((__bridge const void *)cls);
        return matches != class_desc.cend();
    }
    
    ClassDescription& ObjCDynamicPropertySynthesizer::_prepareClassIfNeeded(const Class cls) {
        ClassDescription * first_prepared_class_description = nullptr;
        
        ClassDescription * last_prepared_class_description = nullptr;
        
        auto current_class = cls;
        
        while (current_class != nil) {
            auto current_class_raw_name = class_getName(cls);
            auto current_class_name = std::make_unique<std::string>(current_class_raw_name);
            
            if(_isClassDescriptionLoadedForClass(cls)) {
                auto& class_description = _getClassDescriptionForClass(cls);
                class_description.prepareIfNeeded();
                last_prepared_class_description = &class_description;
            } else {
                auto& class_description = _loadClassDescription(cls);
                if (!class_description.isParent(* last_prepared_class_description)) {
                    last_prepared_class_description -> setParent(class_description);
                }
                last_prepared_class_description = &class_description;
            }
            
            if (first_prepared_class_description == nullptr) {
                first_prepared_class_description = last_prepared_class_description;
            }
            
            current_class = class_getSuperclass(current_class);
        }
        
        assert(first_prepared_class_description != nullptr);
        assert(last_prepared_class_description != nullptr);
        
        return * first_prepared_class_description;
    }
    
    ClassDescription& ObjCDynamicPropertySynthesizer::_loadClassDescription(const Class cls) {
        assert(_classDescriptions().find((__bridge const void *)cls) == _classDescriptions().cend());
        
        auto class_description = std::make_unique<ClassDescription>(* this, cls);
        auto emplaced = _classDescriptions().emplace((__bridge const void *)cls, std::move(class_description));
        return * emplaced.first -> second;
    }
    
#pragma mark Managing Protocol Descriptions
    ProtocolDescription& ObjCDynamicPropertySynthesizer::getProtocolDescriptionForProtocol(const Protocol * protocol) {
        auto& protocol_desc = _protocolDescriptions();
        auto matches = protocol_desc.find((__bridge const void *)protocol);
        if (matches != protocol_desc.cend()) {
            auto& protocol_description = matches -> second;
            return * protocol_description;
        } else {
            auto protocol_description = std::make_unique<ProtocolDescription>(protocol);
            auto emplaced = protocol_desc.emplace((__bridge const void *)protocol, std::move(protocol_description));
            return * emplaced.first -> second;
        }
    }
    
    ObjCDynamicPropertySynthesizer::ProtocolDescriptionUnorderedMap& ObjCDynamicPropertySynthesizer::_protocolDescriptions() {
        return * protocol_descriptions_;
    }
    
    bool ObjCDynamicPropertySynthesizer::isProtocolDescriptionLoaded(const Protocol * protocol) {
        auto& protocol_desc = _protocolDescriptions();
        auto matches = protocol_desc.find((__bridge const void *)protocol);
        return matches != protocol_desc.cend();
    }
    
#pragma mark Managing Lock
    void ObjCDynamicPropertySynthesizer::lock() {
        auto lock_signal = pthread_mutex_lock(&lock_);
        if (lock_signal == EINVAL) {
            [NSException raise:NSInternalInconsistencyException format:@"Invalid mutex."];
        }
        if (lock_signal == EDEADLK) {
            [NSException raise:NSInternalInconsistencyException format:@"Deadlocked."];
        }
        lock_owner_ = pthread_self();
    }
    
    void ObjCDynamicPropertySynthesizer::unlock() {
        lock_owner_ = NULL;
        auto unlock_signal = pthread_mutex_unlock(&lock_);
        if (unlock_signal == EINVAL) {
            [NSException raise:NSInternalInconsistencyException format:@"Invalid mutex."];
        }
        if (unlock_signal == EPERM) {
            [NSException raise:NSInternalInconsistencyException format:@"Current thread doesn't hold a lock on mutex."];
        }
    }
    
    void ObjCDynamicPropertySynthesizer::_initLock() {
        pthread_mutexattr_t mutexattr_type;
        
        auto signal = pthread_mutexattr_init(&mutexattr_type);
        if (signal == ENOMEM) {
            [NSException raise:NSInternalInconsistencyException format:@"Not enough memory for initializing mutex attribute."];
        }
        signal = pthread_mutexattr_settype(&mutexattr_type, PTHREAD_MUTEX_ERRORCHECK);
        if (signal == EINVAL) {
            [NSException raise:NSInternalInconsistencyException format:@"Invalid mutex type."];
        }
        
        signal = pthread_mutex_init(&lock_, &mutexattr_type);
        if (signal == ENOMEM) {
            [NSException raise:NSInternalInconsistencyException format:@"The process cannot allocate enough memory to create another mutex."];
        }
        if (signal == EINVAL) {
            [NSException raise:NSInternalInconsistencyException format:@"Invalid mutex attribute."];
        }
        
        signal = pthread_mutexattr_destroy(&mutexattr_type);
        if (signal == EINVAL) {
            [NSException raise:NSInternalInconsistencyException format:@"Invalid mutex attribute."];
        }
    }
    
    void ObjCDynamicPropertySynthesizer::_destroyLock() {
        auto signal = pthread_mutex_destroy(&lock_);
        if (signal == EINVAL) {
            [NSException raise:NSInternalInconsistencyException format:@"Invalid mutex."];
        }
        if (signal == EBUSY) {
            [NSException raise:NSInternalInconsistencyException format:@"Mutex is locked by another thread."];
        }
    }
    
#pragma mark Managing Life Cycle
    ObjCDynamicPropertySynthesizer::ObjCDynamicPropertySynthesizer():
        class_descriptions_ (std::make_unique<ClassDescriptionUnorderedMap>()),
        protocol_descriptions_ (std::make_unique<ProtocolDescriptionUnorderedMap>()),
        implementation_storage_ (std::make_unique<ImplementationStorage>())
    {
        _initLock();
    }
    
    ObjCDynamicPropertySynthesizer::~ObjCDynamicPropertySynthesizer() {
        _destroyLock();
    }
}

#pragma mark - Utilities
static const ObjCDynamicPropertyAttributes ObjCDynamicPropertyAttributesMakeWithAccessorDescription(const objcdd::AccessorDescription& accessor_description) {
    ObjCDynamicPropertyAttributes attributes = ObjCDynamicPropertyAttributeNone;
    if (accessor_description.isCopy()) {
        attributes |= ObjCDynamicPropertyAttributeCopy;
    }
    if (accessor_description.isRetain()) {
        attributes |= ObjCDynamicPropertyAttributeRetain;
    }
    if (accessor_description.isNonatomic()) {
        attributes |= ObjCDynamicPropertyAttributeNonatomic;
    }
    if (accessor_description.isWeak()) {
        attributes |= ObjCDynamicPropertyAttributeWeak;
    }
    return attributes;
}
