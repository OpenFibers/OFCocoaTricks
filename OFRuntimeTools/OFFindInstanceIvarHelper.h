//
//  OFFindInstanceIvarHelper.h
//  OFCocoaTricks
//
//  Created by openthread on 06/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OFFindInstanceIvarHelperRelationshipObject : NSObject
@property (nonatomic, strong) NSString *relationShip;
@property (nonatomic, strong) Class superObjectClass;
@property (nonatomic, assign) uintptr_t superObjectPointer;
@property (nonatomic, strong) NSString *ivarName;
@property (nonatomic, strong) NSString *ivarType;
@property (nonatomic, strong) Class ivarDeclaredInClass;
@property (nonatomic, strong) NSArray <OFFindInstanceIvarHelperRelationshipObject *> *subrelationships;
@end

@interface OFFindInstanceIvarHelper : NSObject

+ (NSArray <OFFindInstanceIvarHelperRelationshipObject *> *)IvarRefsOfObject:(NSObject *)object inSuperObject:(NSObject *)superObject;

@end
