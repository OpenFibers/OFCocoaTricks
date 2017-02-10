//
//  OFFindViewReferenceHelper.m
//  OFCocoaTricks
//
//  Created by openthread on 07/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import "OFFindViewReferenceHelper.h"
#import "OFFindInstanceIvarHelper.h"

@implementation UIView (OFFindViewReferenceHelper)

- (NSArray <NSString *> *)referenceInOtherObjects
{
    return [OFFindViewReferenceHelper findReferenceForView:self];
}

@end

@implementation OFFindViewReferenceHelper

+ (NSArray <NSString *> *)findReferenceForView:(UIView *)view
{
    NSMutableArray *result = [NSMutableArray array];
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
    {
        NSArray *singleResult = [OFFindInstanceIvarHelper IvarNamesOfObject:view inSuperObject:responder];
        if (singleResult)
        {
            [result addObjectsFromArray:singleResult];
        }
    }
    
    return [NSArray arrayWithArray:result];
}

@end
