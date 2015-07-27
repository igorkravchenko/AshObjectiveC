
#import "MotionControls.h"

@implementation MotionControls

- (instancetype)initWithLeft:(NSUInteger)left
                       right:(NSUInteger)right
                  accelerate:(NSUInteger)accelerate
            accelerationRate:(float)accelerationRate
                rotationRate:(float)rotationRate
{
    self = [super init];
    if (self)
    {
        _left = left;
        _right = right;
        _accelerate = accelerate;
        _accelerationRate = accelerationRate;
        _rotationRate = rotationRate;
    }

    return self;
}

@end
