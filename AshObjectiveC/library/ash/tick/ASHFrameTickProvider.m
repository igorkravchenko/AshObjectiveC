
#import "ASHFrameTickProvider.h"
#import <QuartzCore/QuartzCore.h>

@implementation ASHFrameTickProvider
{
    CFTimeInterval previousTime;
    double maximumFrameTime;
    
    NSTimer * timer;
}

@synthesize timeAdjustment;

- (id)initWithMaximumFrameTime:(double)aMaximumFrameTime
{
    self = [super init];
    
    if (self != nil)
    {
        maximumFrameTime = aMaximumFrameTime;
        timeAdjustment = 1;
    }
    
    return self;
}

- (void)start
{
    if (timer == nil)
    {
        previousTime = CACurrentMediaTime();
        
        timer =  [NSTimer scheduledTimerWithTimeInterval:maximumFrameTime
                                                  target:self
                                                selector:@selector(dispatchTick:) userInfo:nil
                                                 repeats:YES];
    }
}

- (void)stop
{
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)dispatchTick:(NSTimer *)tickTimer
{
    CFTimeInterval temp = previousTime;
    previousTime = CACurrentMediaTime();
    CFTimeInterval frameTime = previousTime - temp;
    
    if (frameTime > maximumFrameTime)
    {
        frameTime = maximumFrameTime;
    }
    
    [self dispatchWithObject:
     @(frameTime * timeAdjustment)];
}

- (BOOL)playing
{
    return timer == nil ? NO : timer.isValid;
}

@end
