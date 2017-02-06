//
//  OFFindInstanceIvarHelper.m
//  OFCocoaTricks
//
//  Created by openthread on 06/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import "OFFindInstanceIvarHelper.h"
#import <objc/runtime.h>

@implementation OFFindInstanceIvarHelper

+ (NSArray <NSString *> *)IvarNamesOfObject:(NSObject *)object inSuperObject:(NSObject *)superObject
{
    unsigned int count;
    Ivar *vars = class_copyIvarList([self class], &count);
    for (NSUInteger i=0; i<count; i++)
    {
        Ivar var = vars[i];
        NSLog(@"%s %s", ivar_getName(var), ivar_getTypeEncoding(var));
    }
    return nil;
}

@end
