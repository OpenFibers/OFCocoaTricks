//
//  NMDebugTool.m
//  NeteaseMusic
//
//  Created by openthread on 11/23/12.
//
//

#import "OTTimeProfileTool.h"
#import <mach/mach_time.h>

@implementation OTTimeProfileTool
{
    NSMutableArray *_cpuTimeArray;
    mach_timebase_info_data_t info;
    uint64_t start;
    
    NSString *_userInfo;
    
    double _mSecond;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _mSecond = 0.0f;
        _cpuTimeArray = [NSMutableArray array];
#if !__has_feature(objc_arc)
        [_cpuTimeArray retain];
#endif
    }
    return self;
}

- (id)initWithInfo:(NSString *)infoString
{
    self = [self init];
    if (self)
    {
        _userInfo = infoString;
#if !__has_feature(objc_arc)
        [_userInfo retain];
#endif
    }
    return self;
}

- (id)initWithInfo:(NSString *)infoString minLogTime:(double)mSecond
{
    self = [self initWithInfo:infoString];
    if (self)
    {
        _mSecond = mSecond;
    }
    return self;
}

- (void)beginFlagCPUTime
{
    if (mach_timebase_info(&info) != KERN_SUCCESS) {};
    start = mach_absolute_time ();
}

- (void)flagCPUTime
{
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    uint64_t nanos = elapsed * info.numer / info.denom;
    double ms = 1000.0f * (double)nanos / NSEC_PER_SEC;
    [_cpuTimeArray addObject:[NSNumber numberWithDouble:ms]];
}

- (void)endFlagCPUTime
{
    [self flagCPUTime];
    
    NSMutableString *string = [NSMutableString string];
#if !__has_feature(objc_arc)
    [string retain];
#endif
    
    if (_userInfo)
    {
        [string appendString:_userInfo];
    }
    
    double lastFlag = 0.0f;
    for (NSNumber *number in _cpuTimeArray)
    {
        double flag = [number doubleValue];
        double timeAdded = flag - lastFlag;
        lastFlag = flag;
        [string appendFormat:@"\n#%lu from begin:%fms from last flag:%fms", (unsigned long)[_cpuTimeArray indexOfObject:number], flag, timeAdded];
    }
    
    if (_mSecond <= 0.0f || lastFlag > _mSecond)
    {
        NSLog(@"%@",string);
    }
    
#if !__has_feature(objc_arc)
    [string release];
#endif
}

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [_cpuTimeArray release];
    [_userInfo release];
    [super dealloc];
#endif
}

@end
