
#import "ASHSignal1.h"
#import "ASHTickProvider.h"

@interface ASHFixedTickProvider : ASHSignal1 <ASHTickProvider>

@property (nonatomic, assign) CGFloat timeAdjustment;

- (id)initWithFrameTime:(CGFloat)frameTime;

@end
