
#import "Gun.h"

@implementation Gun

- (id)initWithOffestX:(float)offsetX
              offsetY:(float)offsetY
  minimumShotInterval:(float)minimumShotInterval
       bulletLifetime:(float)bulletLifetime
{
    self = [super init];
    
    if (self != nil)
    {
        _shooting = NO;
        _offsetFromParent = CGPointMake(offsetX, offsetY);
        _timeSinceLastShot = 0;
        _minimumShotInterval = minimumShotInterval;
        _bulletLifetime = bulletLifetime;
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];

    if (self != nil)
    {
        _shooting = NO;
        _offsetFromParent = CGPointZero;
        _timeSinceLastShot = 0.f;
        _minimumShotInterval = 0.f;
        _bulletLifetime = 0.f;
    }

    return self;
}


@end
