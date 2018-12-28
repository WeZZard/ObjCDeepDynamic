//
//  ObjCDynamicPropertyAccessors.mm
//  ObjCDeepDynamic
//
//  Created by WeZZard on 25/12/2016.
//
//

#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizer.h>
#import <ObjCDeepDynamic/ObjCDynamicPropertySynthesizing.h>
#import "_OBJCDDWeakValue.h"

#if TARGET_CPU_X86 || TARGET_CPU_X86_64
#import "_OBJCDDFloat80Value.h"
#endif

#pragma mark - id
@ObjCDynamicPropertyGetter(id, RETAIN) {
    @synchronized (self) {
        return [self primitiveValueForKey:_prop];
    }
};

@ObjCDynamicPropertySetter(id, RETAIN) {
    @synchronized (self) {
        [self setPrimitiveValue:newValue forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(id, WEAK) {
    @synchronized (self) {
        return [(_OBJCDDWeakValue *)[self primitiveValueForKey:_prop] object];
    }
};

@ObjCDynamicPropertySetter(id, WEAK) {
    @synchronized (self) {
        NSString * key = _prop;
        _OBJCDDWeakValue * weakContainer = [self primitiveValueForKey:key];
        if (weakContainer) {
            weakContainer.object = newValue;
        } else {
            [self setPrimitiveValue:[[_OBJCDDWeakValue alloc] initWithObject:newValue] forKey:key];
        }
    }
};

@ObjCDynamicPropertyGetter(id, COPY) {
    @synchronized (self) {
        return [self primitiveValueForKey:_prop];
    }
};

@ObjCDynamicPropertySetter(id, COPY) {
    @synchronized (self) {
        [self setPrimitiveValue:[newValue copy] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(id, RETAIN, NONATOMIC) {
    return [self primitiveValueForKey:_prop];
};

@ObjCDynamicPropertySetter(id, RETAIN, NONATOMIC) {
    [self setPrimitiveValue:newValue forKey:_prop];
};

@ObjCDynamicPropertyGetter(id, WEAK, NONATOMIC) {
    return [(_OBJCDDWeakValue *)[self primitiveValueForKey:_prop] object];
};

@ObjCDynamicPropertySetter(id, WEAK, NONATOMIC) {
    NSString * key = _prop;
    _OBJCDDWeakValue * weakContainer = [self primitiveValueForKey:key];
    if (weakContainer) {
        weakContainer.object = newValue;
    } else {
        [self setPrimitiveValue:[[_OBJCDDWeakValue alloc] initWithObject:newValue] forKey:key];
    }
};

@ObjCDynamicPropertyGetter(id, COPY, NONATOMIC) {
    return [self primitiveValueForKey:_prop];
};

@ObjCDynamicPropertySetter(id, COPY, NONATOMIC) {
    [self setPrimitiveValue:[newValue copy] forKey:_prop];
};

#pragma mark - SEL
@ObjCDynamicPropertyGetter(SEL) {
    @synchronized (self) {
        return NSSelectorFromString([self primitiveValueForKey:_prop]);
    }
};

@ObjCDynamicPropertySetter(SEL) {
    @synchronized (self) {
        [self setPrimitiveValue:NSStringFromSelector(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(SEL, NONATOMIC) {
    return NSSelectorFromString([self primitiveValueForKey:_prop]);
};

@ObjCDynamicPropertySetter(SEL, NONATOMIC) {
    [self setPrimitiveValue:NSStringFromSelector(newValue) forKey:_prop];
};

#pragma mark - void *
@ObjCDynamicPropertyGetter(void *) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] pointerValue];
    }
};

@ObjCDynamicPropertySetter(void *) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithPointer:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(void *, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] pointerValue];
};

@ObjCDynamicPropertySetter(void *, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithPointer:newValue] forKey:_prop];
};

#pragma mark - char
@ObjCDynamicPropertyGetter(char) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] charValue];
    }
};

@ObjCDynamicPropertySetter(char) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(char, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] charValue];
};

@ObjCDynamicPropertySetter(char, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};

#pragma mark - int
@ObjCDynamicPropertyGetter(int) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] intValue];
    }
};

@ObjCDynamicPropertySetter(int) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(int, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] intValue];
};

@ObjCDynamicPropertySetter(int, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};

#pragma mark - short
@ObjCDynamicPropertyGetter(short) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] shortValue];
    }
};

@ObjCDynamicPropertySetter(short) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(short, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] shortValue];
};

@ObjCDynamicPropertySetter(short, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};

#pragma mark - long
#if !__LP64__
@ObjCDynamicPropertyGetter(long) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] longValue];
    }
};

@ObjCDynamicPropertySetter(long) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(long, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] longValue];
};

@ObjCDynamicPropertySetter(long, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};
#endif

#pragma mark - long long
@ObjCDynamicPropertyGetter(long long) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] longLongValue];
    }
};

@ObjCDynamicPropertySetter(long long) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(long long, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] longLongValue];
};

@ObjCDynamicPropertySetter(long long, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};

#pragma mark - unsigned char
@ObjCDynamicPropertyGetter(unsigned char) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] unsignedCharValue];
    }
};

@ObjCDynamicPropertySetter(unsigned char) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(unsigned char, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] unsignedCharValue];
};

@ObjCDynamicPropertySetter(unsigned char, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};

#pragma mark - unsigned int
@ObjCDynamicPropertyGetter(unsigned int) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] unsignedIntValue];
    }
};

@ObjCDynamicPropertySetter(unsigned int) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(unsigned int, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] unsignedIntValue];
};

@ObjCDynamicPropertySetter(unsigned int, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};

#pragma mark - unsigned short
@ObjCDynamicPropertyGetter(unsigned short) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] unsignedShortValue];
    }
};

@ObjCDynamicPropertySetter(unsigned short) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(unsigned short, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] unsignedShortValue];
};

@ObjCDynamicPropertySetter(unsigned short, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};

#pragma mark - unsigned long
#if !__LP64__
@ObjCDynamicPropertyGetter(unsigned long) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] unsignedLongValue];
    }
};

@ObjCDynamicPropertySetter(unsigned long) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(unsigned long, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] unsignedLongValue];
};

@ObjCDynamicPropertySetter(unsigned long, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};
#endif

#pragma mark - unsigned long long
@ObjCDynamicPropertyGetter(unsigned long long) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] unsignedLongLongValue];
    }
};

@ObjCDynamicPropertySetter(unsigned long long) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(unsigned long long, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] unsignedLongLongValue];
};

@ObjCDynamicPropertySetter(unsigned long long, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};

#pragma mark - float
@ObjCDynamicPropertyGetter(float) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] floatValue];
    }
};

@ObjCDynamicPropertySetter(float) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(float, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] floatValue];
};

@ObjCDynamicPropertySetter(float, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};

#pragma mark - double
@ObjCDynamicPropertyGetter(double) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] doubleValue];
    }
};

@ObjCDynamicPropertySetter(double) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(double, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] doubleValue];
};

@ObjCDynamicPropertySetter(double, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};

#if TARGET_CPU_X86 || TARGET_CPU_X86_64
@ObjCDynamicPropertyGetter(long double) {
    return [[self primitiveValueForKey:_prop] float80Value];
};

@ObjCDynamicPropertySetter(long double) {
    [self setPrimitiveValue:[[_OBJCDDFloat80Value alloc] initWithFloat80: newValue] forKey:_prop];
};

@ObjCDynamicPropertyGetter(long double, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] float80Value];
};

@ObjCDynamicPropertySetter(long double, NONATOMIC) {
    [self setPrimitiveValue:[[_OBJCDDFloat80Value alloc] initWithFloat80: newValue] forKey:_prop];
};
#endif

#pragma mark - BOOL
#if __LP64__
@ObjCDynamicPropertyGetter(BOOL) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] boolValue];
    }
};

@ObjCDynamicPropertySetter(BOOL) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(BOOL, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] boolValue];
};

@ObjCDynamicPropertySetter(BOOL, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};
#endif

#pragma mark - _Bool
#if !__LP64__
@ObjCDynamicPropertyGetter(_Bool) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] boolValue];
    }
};

@ObjCDynamicPropertySetter(_Bool) {
    @synchronized (self) {
        [self setPrimitiveValue:@(newValue) forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(_Bool, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] boolValue];
};

@ObjCDynamicPropertySetter(_Bool, NONATOMIC) {
    [self setPrimitiveValue:@(newValue) forKey:_prop];
};
#endif

#pragma mark - NSRange
@ObjCDynamicPropertyGetter(NSRange) {
    @synchronized (self) {
        return [[self primitiveValueForKey:_prop] rangeValue];
    }
};

@ObjCDynamicPropertySetter(NSRange) {
    @synchronized (self) {
        [self setPrimitiveValue:[NSValue valueWithRange:newValue] forKey:_prop];
    }
};

@ObjCDynamicPropertyGetter(NSRange, NONATOMIC) {
    return [[self primitiveValueForKey:_prop] rangeValue];
};

@ObjCDynamicPropertySetter(NSRange, NONATOMIC) {
    [self setPrimitiveValue:[NSValue valueWithRange:newValue] forKey:_prop];
};
