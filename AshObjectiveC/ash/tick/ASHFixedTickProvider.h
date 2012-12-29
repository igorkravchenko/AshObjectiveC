
#import "ASHSignal1.h"
#import "ASHTickProvider.h"

@interface ASHFixedTickProvider : ASHSignal1 <ASHTickProvider>

@property (nonatomic, assign) double timeAdjustment;

- (id)initWithFrameTime:(double)frameTime;

@end
