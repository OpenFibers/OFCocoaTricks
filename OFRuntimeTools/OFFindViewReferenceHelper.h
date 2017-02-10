//
//  OFFindViewReferenceHelper.h
//  OFCocoaTricks
//
//  Created by openthread on 07/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (OFFindViewReferenceHelper)

- (NSArray <NSString *> *)referenceInOtherObjects;

@end

@interface OFFindViewReferenceHelper : NSObject

+ (NSArray <NSString *> *)findReferenceForView:(UIView *)view;

@end
