//
//  ViewController.m
//  OFCocoaTricks
//
//  Created by openthread on 02/01/2017.
//  Copyright © 2017 openfibers. All rights reserved.
//

#import "ViewController.h"
#import "OTTimeProfileTool.h"
#import "OFGetSubclassesHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i = 0; i < 10; i++)
    {
        OTTimeProfileTool *timeProfile = [[OTTimeProfileTool alloc] init];
        [timeProfile beginFlagCPUTime];
        NSArray *a = [OFGetSubclassesHelper getAllSubclassesOfClass:[NSObject class]];
        [timeProfile endFlagCPUTime];
        NSLog(@"%@", a);
    }
}

@end
