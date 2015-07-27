
#import "Position.h"

@implementation Position

- (instancetype)initWithX:(float)x
                        y:(float)y
                 rotation:(float)rotation
{
    self = [super init];
    if (self)
    {
        _rotation = rotation;
        _position = CGPointMake(x, y);
    }

    return self;
}


@end
