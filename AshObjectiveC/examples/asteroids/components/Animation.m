
#import "Animation.h"

@implementation Animation

- (instancetype)initWithAnimation:(id <Animatable>)animation
{
    self = [super init];
    if (self)
    {
        self.animation = animation;
    }

    return self;
}


@end
