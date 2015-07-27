
#import "Spaceship.h"

@implementation Spaceship

- (instancetype)initWithFsm:(ASHEntityStateMachine *)fsm
{
    self = [super init];
    if (self)
    {
        _fsm = fsm;
    }

    return self;
}

@end
