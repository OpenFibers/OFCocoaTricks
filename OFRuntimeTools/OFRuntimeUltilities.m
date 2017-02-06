//
//  OFRuntimeUltilities.m
//  OFCocoaTricks
//
//  Created by openthread on 06/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import "OFRuntimeUltilities.h"
#import <objc/runtime.h>

@implementation OFRuntimeUltilities

//copyed from FLEXRuntimeUltility
+ (id)valueForIvar:(Ivar)ivar onObject:(id)object
{
    id value = nil;
    const char *type = ivar_getTypeEncoding(ivar);
#ifdef __arm64__
    // See http://www.sealiesoftware.com/blog/archive/2013/09/24/objc_explain_Non-pointer_isa.html
    const char *name = ivar_getName(ivar);
    if (type[0] == @encode(Class)[0] && strcmp(name, "isa") == 0) {
        value = object_getClass(object);
    } else
#endif
        if (type[0] == @encode(id)[0] || type[0] == @encode(Class)[0]) {
            value = object_getIvar(object, ivar);
        } else {
            ptrdiff_t offset = ivar_getOffset(ivar);
            void *pointer = (__bridge void *)object + offset;
            value = [self valueForPrimitivePointer:pointer objCType:type];
        }
    return value;
}

//copyed from FLEXRuntimeUltility
+ (NSValue *)valueForPrimitivePointer:(void *)pointer objCType:(const char *)type
{
    // CASE macro inspired by https://www.mikeash.com/pyblog/friday-qa-2013-02-08-lets-build-key-value-coding.html
#define CASE(ctype, selectorpart) \
if(strcmp(type, @encode(ctype)) == 0) { \
return [NSNumber numberWith ## selectorpart: *(ctype *)pointer]; \
}
    
    CASE(BOOL, Bool);
    CASE(unsigned char, UnsignedChar);
    CASE(short, Short);
    CASE(unsigned short, UnsignedShort);
    CASE(int, Int);
    CASE(unsigned int, UnsignedInt);
    CASE(long, Long);
    CASE(unsigned long, UnsignedLong);
    CASE(long long, LongLong);
    CASE(unsigned long long, UnsignedLongLong);
    CASE(float, Float);
    CASE(double, Double);
    
#undef CASE
    
    NSValue *value = nil;
    @try {
        value = [NSValue valueWithBytes:pointer objCType:type];
    } @catch (NSException *exception) {
        // Certain type encodings are not supported by valueWithBytes:objCType:. Just fail silently if an exception is thrown.
    }
    
    return value;
}

@end
