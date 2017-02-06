//
//  OFRuntimeUltilities.h
//  OFCocoaTricks
//
//  Created by openthread on 06/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface OFRuntimeUltilities : NSObject

+ (id)valueForIvar:(Ivar)ivar onObject:(id)object;

+ (NSValue *)valueForPrimitivePointer:(void *)pointer objCType:(const char *)type;

@end
