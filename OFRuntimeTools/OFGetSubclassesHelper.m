//
//  OFGetSubclassesHelper.m
//  OFCocoaTricks
//
//  Created by openthread on 02/01/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import "OFGetSubclassesHelper.h"
#import <objc/runtime.h>

@implementation OFGetSubclassesHelper

+ (BOOL)isClass:(const Class)subclass subclassOfClass:(const Class)aClass
{
    if (!subclass || !aClass || subclass == aClass)
    {
        return NO;
    }
    Class tempClass = subclass;
    while (tempClass && tempClass != aClass)
    {
        //这里不能使用isSubclassOfClass:，因为此方法是 NSObject 的方法。
        tempClass = class_getSuperclass(tempClass);
    }
    
    BOOL isSubclass = (tempClass == aClass);
    return isSubclass;
}

+ (NSArray *)getAllSubclassesOfClass:(Class)aClass
{
    Class *classCache = NULL;
    int numOfClasses = objc_getClassList(NULL, 0);
    NSMutableArray *classArray = [NSMutableArray array];
    if (numOfClasses > 0 )
    {
        classCache = (Class *)malloc(sizeof(Class) * numOfClasses);
        numOfClasses = objc_getClassList(classCache, numOfClasses);
        for (int i = 0; i < numOfClasses; ++i)
        {
            Class currentClass = classCache[i];
            if (currentClass)
            {
                if ([self isClass:currentClass subclassOfClass:aClass])
                {
                    [classArray addObject:currentClass];
                }
            }
        }
        free(classCache);
    }
    
    return [NSArray arrayWithArray:classArray];
}

@end
