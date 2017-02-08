//
//  OFFindInstanceIvarHelper.m
//  OFCocoaTricks
//
//  Created by openthread on 06/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import "OFFindInstanceIvarHelper.h"
#import "OFRuntimeUltilities.h"
#import <objc/runtime.h>

@implementation OFFindInstanceIvarHelper

+ (NSArray <NSString *> *)IvarNamesOfObject:(NSObject *)object inSuperObject:(NSObject *)superObject
{
    if (!superObject)
    {
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    unsigned int count;
    Ivar *vars = class_copyIvarList([superObject class], &count);
    for (NSUInteger i = 0; i < count; i++)
    {
        Ivar var = vars[i];
        const char *type = ivar_getTypeEncoding(var);
        
        if (type[0] == @encode(id)[0])
        {
            ptrdiff_t offset = ivar_getOffset(var);
            uintptr_t *pointer = (__bridge void *)superObject + offset;
            if (*pointer == (uintptr_t)(__bridge void *)object)
            {
                NSString *result = [NSString stringWithFormat:@"EQUAL_TO %@(%lx) %s %s", [superObject class], (uintptr_t)superObject, ivar_getName(var), type];
                [resultArray addObject:result];
            }
            else
            {
                id value = [OFRuntimeUltilities valueForIvar:var onObject:superObject];
                if ([object isKindOfClass:[UIView class]] && [value isKindOfClass:[UIView class]])
                {
                    UIView *viewValue = value;
                    if ([viewValue.subviews containsObject:(UIView *)object])
                    {
                        NSString *result = [NSString stringWithFormat:@"SUBVIEW_OF %@(%lx) %s %s", [superObject class], (uintptr_t)superObject, ivar_getName(var), type];
                        [resultArray addObject:result];
                    }
                    else if ([((UIView *)object) isDescendantOfView:viewValue])
                    {
                        NSString *result = [NSString stringWithFormat:@"DESCENDANTVIEW_OF %@(%lx) %s %s", [superObject class], (uintptr_t)superObject, ivar_getName(var), type];
                        [resultArray addObject:result];
                    }
                }
                if ([value respondsToSelector:@selector(objectEnumerator)])
                {
                    NSEnumerator *enumerator = [value objectEnumerator];
                    if ([enumerator isKindOfClass:[NSEnumerator class]])
                    {
                        id element = nil;
                        while ((element = [enumerator nextObject]))
                        {
                            if (element == object)
                            {
                                NSString *result = [NSString stringWithFormat:@"VALUE_OF %@(%lx) %s %s", [superObject class], (uintptr_t)superObject, ivar_getName(var), type];
                                [resultArray addObject:result];
                            }
                        }
                    }
                }
                if ([value respondsToSelector:@selector(keyEnumerator)])
                {
                    NSEnumerator *enumerator = [value keyEnumerator];
                    if ([enumerator isKindOfClass:[NSEnumerator class]])
                    {
                        id element = nil;
                        while ((element = [enumerator nextObject]))
                        {
                            if (element == object)
                            {
                                NSString *result = [NSString stringWithFormat:@"KEY_OF %@(%lx) %s %s", [superObject class], (uintptr_t)superObject, ivar_getName(var), type];
                                [resultArray addObject:result];
                            }
                        }
                    }
                }
            }
        }
    }
    
    return [NSArray arrayWithArray:resultArray];
}

@end
