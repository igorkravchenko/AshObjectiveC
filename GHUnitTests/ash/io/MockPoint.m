
#import "MockPoint.h"

@implementation MockPoint
{

}

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y
{
    self = [super init];
    if (self)
    {
        self.x = x;
        self.y = y;
    }

    return self;
}

+ (instancetype)pointWithX:(CGFloat)x y:(CGFloat)y
{
    return [[self alloc] initWithX:x y:y];
}


@end