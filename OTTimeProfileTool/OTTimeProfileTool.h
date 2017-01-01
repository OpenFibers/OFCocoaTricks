//
//  NMDebugTool.h
//  NeteaseMusic
//
//  Created by openthread on 11/23/12.
//
//  Profile elapsed CPU time of codes.
//  How to use:
//  1. Init an OTTimeProfileTool
//  2. call beginFlagCPUTime and several flagCPUTime in codes.
//  3. call endFlagCPUTime and see logs.

#import <Foundation/Foundation.h>

@interface OTTimeProfileTool : NSObject

//Init
- (id)init;

//`infoString` will be printed when `endFlagCPUTime` get called
- (id)initWithInfo:(NSString *)infoString;

//if elapsed time < `mSecond`, log will be printed
//if `mSecond` <= 0, all log will be printed
- (id)initWithInfo:(NSString *)infoString minLogTime:(double)mSecond;

//begin profile
- (void)beginFlagCPUTime;

- (void)flagCPUTime;

//end profile and print all log
- (void)endFlagCPUTime;

@end
