
#import "Collision.h"

@implementation Collision

- (instancetype)initWithRadius:(float)radius
{
    self = [super init];
    if (self)
    {
        _radius = radius;
    }

    return self;
}

@end
