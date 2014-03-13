
#import "ASHSignal1.h"
#import "ASHTickProvider.h"

@interface ASHFrameTickProvider : ASHSignal1 <ASHTickProvider>

@property (nonatomic, assign) double timeAdjustment;


- (id)initWithMaximumFrameTime:(double)aMaximumFrameTime;

@end
