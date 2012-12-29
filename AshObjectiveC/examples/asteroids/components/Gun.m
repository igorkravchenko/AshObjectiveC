
#import "Gun.h"

@implementation Gun

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _shooting = NO;
        _offsetFromParent = CGPointZero;
        _timeSinceLastShot = 0.;
        _minimumShotInterval = 0.;
        _bulletLifetime = 0.;
    }
    
    return self;
}

@end
