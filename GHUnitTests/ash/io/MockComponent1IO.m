
#import "MockComponent1IO.h"


@implementation MockComponent1IO
{

}

- (instancetype)initWithX:(NSInteger)x
                        y:(NSInteger)y
{
    self = [super init];
    if (self)
    {
        _x = x;
        _y = y;
    }

    return self;
}

@end