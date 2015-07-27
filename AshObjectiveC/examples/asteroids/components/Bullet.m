
#import "Bullet.h"

@implementation Bullet

- (instancetype)initWithLifeRemaining:(float)lifetime
{
    self = [super init];
    if (self)
    {
        _lifeRemaining = lifetime;
    }

    return self;
}

@end
