//
//  OFFindViewReferenceTester.m
//  OFCocoaTricks
//
//  Created by openthread on 07/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import "OFFindViewReferenceTester.h"
#import "OFFindViewReferenceHelper.h"

@implementation OFFindViewReferenceTester

+ (void)testForView:(UIView *)view
{
    NSArray *result = [OFFindViewReferenceHelper findReferenceForView:view];
    NSLog(@"%@", result);
}

@end
