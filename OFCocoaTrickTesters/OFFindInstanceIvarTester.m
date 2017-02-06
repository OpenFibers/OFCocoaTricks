//
//  OFFindInstanceIvarTester.m
//  OFCocoaTricks
//
//  Created by openthread on 06/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import "OFFindInstanceIvarTester.h"
#import "OFFindInstanceIvarHelper.h"

@implementation OFFindInstanceIvarTester
{
    NSString *_a;
    NSString *_b;
}

+ (void)test
{
    OFFindInstanceIvarTester *tester = [[OFFindInstanceIvarTester alloc] init];
    NSString *a = [[NSString alloc] init];
    tester->_a = a;
    tester->_b = nil;
    [OFFindInstanceIvarHelper IvarNamesOfObject:a inSuperObject:tester];
    [OFFindInstanceIvarHelper IvarNamesOfObject:nil inSuperObject:tester];
}

@end
