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

@interface OFFindInstanceIvarHelperRelationshipObject()

+ (instancetype)objectWithRelationShip:(NSString *)relationShip
                      superObjectClass:(Class)superObjectClass
                    superObjectPointer:(uintptr_t)superObjectPointer
                              ivarName:(NSString *)ivarName
                              ivarType:(NSString *)ivarType
                   ivarDeclaredInClass:(Class)ivarDeclaredInClass;

@end

@implementation OFFindInstanceIvarHelperRelationshipObject

+ (instancetype)objectWithRelationShip:(NSString *)relationShip
                      superObjectClass:(Class)superObjectClass
                    superObjectPointer:(uintptr_t)superObjectPointer
                              ivarName:(NSString *)ivarName
                              ivarType:(NSString *)ivarType
                   ivarDeclaredInClass:(Class)ivarDeclaredInClass
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

- (void)setSubrelationships:(NSArray<OFFindInstanceIvarHelperRelationshipObject *> *)subrelationships
{
    _subrelationships = subrelationships;
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
    if (self.subrelationships)
    {
        NSMutableString *copiedResult = [result mutableCopy];
        [copiedResult appendString:@"\nsubrelationships:\n"];
        [copiedResult appendString:[self.subrelationships description]];
        result = [NSString stringWithString:copiedResult];
    }
    return result;
}

@end

@implementation OFFindInstanceIvarHelper

+ (NSArray <OFFindInstanceIvarHelperRelationshipObject *> *)IvarRefsOfObject:(NSObject *)object inSuperObject:(NSObject *)superObject
{
    return [self IvarRefsOfObject:object inSuperObject:superObject currentFindingPath:nil];
}

+ (NSArray <OFFindInstanceIvarHelperRelationshipObject *> *)IvarRefsOfObject:(NSObject *)object inSuperObject:(NSObject *)superObject currentFindingPath:(NSArray *)currentFindingPath
{
    if (!superObject)
    {
        return nil;
    }
    
    if ([currentFindingPath containsObject:[NSValue valueWithPointer:(void *)superObject]])
    {
        return nil;
    }
    
    NSArray *nextFindingPath = [(currentFindingPath ?: @[]) arrayByAddingObject:[NSValue valueWithPointer:(void *)superObject]];
    
    NSMutableArray <OFFindInstanceIvarHelperRelationshipObject *> *resultArray = [NSMutableArray array];
    
    Class tempClass = [superObject class];
    while (tempClass)
    {
        unsigned int count;
        Ivar *vars = class_copyIvarList(tempClass, &count);
        for (NSUInteger i = 0; i < count; i++)
        {
            Ivar var = vars[i];
            const char *type = ivar_getTypeEncoding(var);
            
            if (type[0] != @encode(id)[0])
            {
                continue;
            }
            
            ptrdiff_t offset = ivar_getOffset(var);
            uintptr_t *pointer = (__bridge void *)superObject + offset;
            if (*pointer == (uintptr_t)(__bridge void *)object)
            {
                OFFindInstanceIvarHelperRelationshipObject *r;
                r = [OFFindInstanceIvarHelperRelationshipObject objectWithRelationShip:@"EQUAL_TO"
                                                                      superObjectClass:[superObject class]
                                                                    superObjectPointer:(uintptr_t)superObject
                                                                              ivarName:[NSString stringWithUTF8String:ivar_getName(var)]
                                                                              ivarType:[NSString stringWithUTF8String:type]
                                                                   ivarDeclaredInClass:tempClass];
                [resultArray addObject:r];
                continue;
            }
            
            id value = [OFRuntimeUltilities valueForIvar:var onObject:superObject];
            if ([object isKindOfClass:[UIView class]] && [value isKindOfClass:[UIView class]])
            {
                UIView *viewValue = value;
                if ([viewValue.subviews containsObject:(UIView *)object])
                {
                    OFFindInstanceIvarHelperRelationshipObject *r;
                    r = [OFFindInstanceIvarHelperRelationshipObject objectWithRelationShip:@"SUBVIEW_OF"
                                                                          superObjectClass:[superObject class]
                                                                        superObjectPointer:(uintptr_t)superObject
                                                                                  ivarName:[NSString stringWithUTF8String:ivar_getName(var)]
                                                                                  ivarType:[NSString stringWithUTF8String:type]
                                                                       ivarDeclaredInClass:tempClass];
                    [resultArray addObject:r];
                }
                else if ([((UIView *)object) isDescendantOfView:viewValue])
                {
                    OFFindInstanceIvarHelperRelationshipObject *r;
                    r = [OFFindInstanceIvarHelperRelationshipObject objectWithRelationShip:@"DESCENDANTVIEW_OF"
                                                                          superObjectClass:[superObject class]
                                                                        superObjectPointer:(uintptr_t)superObject
                                                                                  ivarName:[NSString stringWithUTF8String:ivar_getName(var)]
                                                                                  ivarType:[NSString stringWithUTF8String:type]
                                                                       ivarDeclaredInClass:tempClass];
                    [resultArray addObject:r];
                }
                continue;
            }
            
            if ([value respondsToSelector:@selector(enumerateObjectsUsingBlock:)])
            {
                [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj == object)
                    {
                        OFFindInstanceIvarHelperRelationshipObject *r;
                        r = [OFFindInstanceIvarHelperRelationshipObject objectWithRelationShip:@"VALUE_OF"
                                                                              superObjectClass:[superObject class]
                                                                            superObjectPointer:(uintptr_t)superObject
                                                                                      ivarName:[NSString stringWithUTF8String:ivar_getName(var)]
                                                                                      ivarType:[NSString stringWithUTF8String:type]
                                                                           ivarDeclaredInClass:tempClass];
                        [resultArray addObject:r];
                    }
                    else
                    {
                        NSArray *relationShips = [OFFindInstanceIvarHelper IvarRefsOfObject:object inSuperObject:value currentFindingPath:nextFindingPath];
                        if (relationShips.count)
                        {
                            OFFindInstanceIvarHelperRelationshipObject *r;
                            r = [OFFindInstanceIvarHelperRelationshipObject objectWithRelationShip:@"SUB_RELATIONSHIP_IN"
                                                                                  superObjectClass:[superObject class]
                                                                                superObjectPointer:(uintptr_t)superObject
                                                                                          ivarName:[NSString stringWithUTF8String:ivar_getName(var)]
                                                                                          ivarType:[NSString stringWithUTF8String:type]
                                                                               ivarDeclaredInClass:tempClass];
                            r.subrelationships = relationShips;
                            [resultArray addObject:r];
                        }
                    }
                }];
            }
            
            NSArray *relationShips = [OFFindInstanceIvarHelper IvarRefsOfObject:object inSuperObject:value currentFindingPath:nextFindingPath];
            if (relationShips.count)
            {
                OFFindInstanceIvarHelperRelationshipObject *r;
                r = [OFFindInstanceIvarHelperRelationshipObject objectWithRelationShip:@"SUB_RELATIONSHIP_IN"
                                                                      superObjectClass:[superObject class]
                                                                    superObjectPointer:(uintptr_t)superObject
                                                                              ivarName:[NSString stringWithUTF8String:ivar_getName(var)]
                                                                              ivarType:[NSString stringWithUTF8String:type]
                                                                   ivarDeclaredInClass:tempClass];
                r.subrelationships = relationShips;
                [resultArray addObject:r];
            }
        }
        
        tempClass = class_getSuperclass(tempClass);
    }
    
    return [NSArray arrayWithArray:resultArray];
}

@end
