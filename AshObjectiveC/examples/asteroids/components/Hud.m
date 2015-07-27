
#import "Hud.h"

@implementation Hud

- (instancetype)initWithView:(HudView *)view
{
    self = [super init];

    if (self)
    {
        _view = view;
    }

    return self;
}

@end