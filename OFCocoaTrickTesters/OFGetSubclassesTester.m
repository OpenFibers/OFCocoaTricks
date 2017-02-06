//
//  OFGetSubclassTester.m
//  OFCocoaTricks
//
//  Created by openthread on 06/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import "OFGetSubclassesTester.h"
#import "OTTimeProfileTool.h"
#import "OFGetSubclassesHelper.h"

@implementation OFGetSubclassesTester

+ (void)test
{
    for (int i = 0; i < 1; i++)
    {
        OTTimeProfileTool *timeProfile = [[OTTimeProfileTool alloc] init];
        [timeProfile beginFlagCPUTime];
        NSArray *a = [OFGetSubclassesHelper getAllSubclassesOfClass:[NSObject class]];
        [timeProfile endFlagCPUTime];
        NSLog(@"%@", a);
    }
}

@end
