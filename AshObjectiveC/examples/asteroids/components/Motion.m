
#import "Motion.h"

@implementation Motion

- (instancetype)initWithVelocityX:(float)velocityX
                        velocityY:(float)velocityY
                  angularVelocity:(float)angularVelocity
                          damping:(float)damping
{
    self = [super init];
    if (self)
    {
        _velocity = CGPointMake(velocityX, velocityY);
        _angularVelocity = angularVelocity;
        _damping = damping;
    }

    return self;
}


- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _velocity = CGPointZero;
        _angularVelocity = 0.f;
        _damping = 0.f;
    }
    
    return self;
}

@end
