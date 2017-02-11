//
//  OFFindInstanceIvarTester.m
//  OFCocoaTricks
//
//  Created by openthread on 06/02/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import "OFFindInstanceIvarTester.h"
#import "OFFindInstanceIvarHelper.h"

@interface A : NSObject
{
    NSObject *_a;
}
@end
@implementation A
@end

@interface B : A
{
    NSObject *_b;
}
@end
@implementation B
@end


@interface OFFindInstanceIvarTester ()
@property (nonatomic, strong) NSString *property;
@end

@implementation OFFindInstanceIvarTester
{
    NSString *_a;
    NSString *_b;
    NSArray *_array;
    NSDictionary *_dictionaryA;
    NSDictionary *_dictionaryB;
}

+ (void)test
{
    B *b = [[B alloc] init];
    NSLog(@"%@", [OFFindInstanceIvarHelper IvarNamesOfObject:nil inSuperObject:b]);
    
    OFFindInstanceIvarTester *tester = [[OFFindInstanceIvarTester alloc] init];
    NSString *a = [[NSString alloc] init];
    tester.property = a;
    tester->_a = a;
    tester->_b = nil;
    tester->_array = @[a];
    tester->_dictionaryA = @{a : @"value"};
    tester->_dictionaryB = @{@"key" : a};
    NSLog(@"%@", [OFFindInstanceIvarHelper IvarNamesOfObject:a inSuperObject:tester]);
    NSLog(@"%@", [OFFindInstanceIvarHelper IvarNamesOfObject:nil inSuperObject:tester]);
}

@end
