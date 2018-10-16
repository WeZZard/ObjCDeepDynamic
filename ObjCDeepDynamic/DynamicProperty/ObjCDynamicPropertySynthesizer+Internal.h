//
//  ObjCDynamicPropertySynthesizer+Internal.hpp
//  ObjCDeepDynamic
//
//  Created by WeZZard on 24/12/2016.
//
//

#ifndef ObjCDynamicPropertySynthesizer_Internal_h
#define ObjCDynamicPropertySynthesizer_Internal_h

#import <Foundation/Foundation.h>
#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizer.h>

#import <objc/objc.h>
#import <objc/runtime.h>

#include <pthread/pthread.h>

#include <string>
#include <vector>
#include <forward_list>
#include <unordered_map>
#include <type_traits>

namespace objcdd {
    enum class AccessorKind;
    class ClassDescription;
    class ProtocolDescription;
    class ImplementationStorage;
    
#pragma mark - ObjCDynamicPropertySynthesizer
    class ObjCDynamicPropertySynthesizer {
    private:
        typedef std::unordered_map<const void *, std::unique_ptr<ClassDescription>> ClassDescriptionUnorderedMap;
        typedef std::unordered_map<const void *, std::unique_ptr<ProtocolDescription>> ProtocolDescriptionUnorderedMap;
        
#pragma mark Accessing the Shared Instance
    public:
        static ObjCDynamicPropertySynthesizer& shared();
        
#pragma mark Accessing Dynamic-Property Related Information
    public:
        bool isClassPrepared(const Class cls);
        
        bool isDynamicProperty(const Class cls, const NSString * key);
        
        const char * getPropertyName(const Class cls, const SEL selector);
        
        bool addImplementation(const IMP imp, const AccessorKind kind, const char * type_encoding, const ObjCDynamicPropertyAttributes attributes);
        
        void setClassSpecificImplementation(const Class cls, const IMP imp, const AccessorKind kind, const char * type_encoding, const ObjCDynamicPropertyAttributes attributes);
        
        void setProtocolSpecificImplementation(const Protocol * protocol, const IMP imp, const AccessorKind kind, const char * type_encoding, const ObjCDynamicPropertyAttributes attributes);
        
#pragma mark Objective-C Class Delegation
    public:
        void classDidAddProperty(Class cls, const char * name, const objc_property_attribute_t * attributes, const unsigned int attribute_count);
        
        void classDidAddProtocol(const Class cls, const Protocol * protocol);
        
#pragma mark Synthesize Property
    public:
        bool synthesizeProperty(const Class cls, const SEL selector);
        
#pragma mark Managing Class Descriptions
    private:
        ClassDescriptionUnorderedMap& _classDescriptions();
        
        ClassDescription& _getClassDescriptionForClass(const Class cls);
        
        bool _isClassDescriptionLoadedForClass(const Class cls);
        
    private:
        ClassDescription& _prepareClassIfNeeded(const Class cls);
        
        ClassDescription& _loadClassDescription(const Class cls);
        
#pragma mark Managing Protocol Descriptions
    public:
        ProtocolDescription& getProtocolDescriptionForProtocol(const Protocol * protocol);
        
    private:
        ProtocolDescriptionUnorderedMap& _protocolDescriptions();
        
        bool isProtocolDescriptionLoaded(const Protocol * protocol);
        
#pragma mark Managing Lock
    public:
        void lock();
        
        void unlock();
        
    private:
        void _initLock();
        
        void _destroyLock();
        
#pragma mark Managing Life Cycle
    public:
        ObjCDynamicPropertySynthesizer();
        ~ObjCDynamicPropertySynthesizer();
        
#pragma mark Instance Variable
    private:
        pthread_mutex_t lock_;
        
        pthread_t lock_owner_;
        
        std::unique_ptr<ClassDescriptionUnorderedMap> class_descriptions_;
        
        std::unique_ptr<ProtocolDescriptionUnorderedMap> protocol_descriptions_;
        
        std::unique_ptr<ImplementationStorage> implementation_storage_;
        
#pragma mark Operator Overloads
    public:
        ObjCDynamicPropertySynthesizer(ObjCDynamicPropertySynthesizer const&) = delete;
        ObjCDynamicPropertySynthesizer(ObjCDynamicPropertySynthesizer&&) = delete;
        ObjCDynamicPropertySynthesizer& operator=(ObjCDynamicPropertySynthesizer const&) = delete;
        ObjCDynamicPropertySynthesizer& operator=(ObjCDynamicPropertySynthesizer &&) = delete;
    };
    
#pragma mark - AccessorKind
    enum class AccessorKind: int {
        getter,
        setter
    };
}

#endif /* ObjCDynamicPropertySynthesizer_Internal_h */
