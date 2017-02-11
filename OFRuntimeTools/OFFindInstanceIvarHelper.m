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

@interface OFFindInstanceIvarHelperRelationshipObject : NSObject
@property (nonatomic, strong) NSString *relationShip;
@property (nonatomic, strong) Class superObjectClass;
@property (nonatomic, assign) uintptr_t superObjectPointer;
@property (nonatomic, strong) NSString *ivarName;
@property (nonatomic, strong) NSString *ivarType;
@property (nonatomic, strong) Class ivarDeclaredInClass;
@end

@implementation OFFindInstanceIvarHelperRelationshipObject

+ (instancetype)objectWithRelationShip:(NSString *)relationShip superObjectClass:(Class)superObjectClass superObjectPointer:(uintptr_t)superObjectPointer ivarName:(NSString *)ivarName ivarType:(NSString *)ivarType ivarDeclaredInClass:(Class)ivarDeclaredInClass
{
    OFFindInstanceIvarHelperRelationshipObject *object = [[OFFindInstanceIvarHelperRelationshipObject alloc] init];
    object.relationShip = relationShip;
    object.superObjectClass = superObjectClass;
    object.superObjectPointer = superObjectPointer;
    object.ivarName = ivarName;
    object.ivarType = ivarType;
    object.ivarDeclaredInClass = ivarDeclaredInClass;
    return object;
}

- (NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"%@ %@(0x%lx) %@ %@",
                        self.relationShip,
                        self.superObjectClass,
                        self.superObjectPointer,
                        self.ivarName,
                        self.ivarType];
    if (self.ivarDeclaredInClass && self.ivarDeclaredInClass != self.superObjectClass)
    {
        NSString *appendingResult = [NSString stringWithFormat:@", declared in %@", self.ivarDeclaredInClass];
        result = [result stringByAppendingString:appendingResult];
    }
    return result;
}

@end

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
                NSString *result = [NSString stringWithFormat:@"EQUAL_TO %@(0x%lx) %s %s", [superObject class], (uintptr_t)superObject, ivar_getName(var), type];
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
                        NSString *result = [NSString stringWithFormat:@"SUBVIEW_OF %@(0x%lx) %s %s", [superObject class], (uintptr_t)superObject, ivar_getName(var), type];
                        [resultArray addObject:result];
                    }
                    else if ([((UIView *)object) isDescendantOfView:viewValue])
                    {
                        NSString *result = [NSString stringWithFormat:@"DESCENDANTVIEW_OF %@(0x%lx) %s %s", [superObject class], (uintptr_t)superObject, ivar_getName(var), type];
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
                                NSString *result = [NSString stringWithFormat:@"VALUE_OF %@(0x%lx) %s %s", [superObject class], (uintptr_t)superObject, ivar_getName(var), type];
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
