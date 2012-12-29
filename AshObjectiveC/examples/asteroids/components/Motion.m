
#import "Motion.h"

@implementation Motion

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _velocity = CGPointZero;
        _angularVelocity = 0.;
        _damping = 0.;
    }
    
    return self;
}

@end
