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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Touch Screen To Test" forState:UIControlStateNormal];
    button.frame = self.view.bounds;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)test
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
