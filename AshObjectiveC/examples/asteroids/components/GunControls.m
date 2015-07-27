
#import "GunControls.h"

@implementation GunControls

- (instancetype)initWithTrigger:(NSUInteger)trigger
{
    self = [super init];
    if (self)
    {
        _trigger = trigger;
    }

    return self;
}

@end
