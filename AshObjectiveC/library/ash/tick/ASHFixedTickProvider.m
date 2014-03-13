
#import "ASHFixedTickProvider.h"

@implementation ASHFixedTickProvider
{
    NSTimer * timer;
    double frameTime;
}

@synthesize timeAdjustment;

- (id)initWithFrameTime:(CGFloat)aFrameTime
{
    self = [super init];
    
    if (self != nil)
    {
        frameTime = aFrameTime;
        timeAdjustment = 1.;
    }
    
    return self;
}

- (void)start
{
    if (timer == nil)
    {
        timer =
        [NSTimer scheduledTimerWithTimeInterval:frameTime
                                         target:self
                                       selector:@selector(dispatchTick:)
                                       userInfo:nil
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

- (void)dispatchTick:(NSTimer *)timer
{
    [super dispatchWithObject:@(frameTime * timeAdjustment)];
}

- (BOOL)playing
{
    return timer == nil ? NO : timer.isValid;
}

@end
