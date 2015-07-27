
#import "DeathThroes.h"

@implementation DeathThroes

- (instancetype)initWithCountdown:(float)duration
{
    self = [super init];
    if (self)
    {
        _countdown = duration;
    }

    return self;
}

@end
