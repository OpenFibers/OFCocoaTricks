//
//  OFGetSubclassesHelper.h
//  OFCocoaTricks
//
//  Created by openthread on 02/01/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFGetSubclassesHelper : NSObject

+ (BOOL)isClass:(const Class)subclass subclassOfClass:(const Class)aClass;

+ (NSArray *)getAllSubclassesOfClass:(Class)aClass;

@end
