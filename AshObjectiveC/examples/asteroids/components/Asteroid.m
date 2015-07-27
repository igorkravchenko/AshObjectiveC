
#import "Asteroid.h"
#import "ASHEntityStateMachine.h"

@implementation Asteroid

- (instancetype)initWithFsm:(ASHEntityStateMachine *)fsm
{
    self = [super init];
    if (self)
    {
        self.fsm = fsm;
    }

    return self;
}

@end
