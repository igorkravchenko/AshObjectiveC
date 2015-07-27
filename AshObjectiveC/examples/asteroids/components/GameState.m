
#import "GameState.h"

@implementation GameState

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _lives = 0;
        _level = 0;
        _hits = 0;
        _playing = NO;
    }
    
    return self;
}

- (void)setForStart
{
    _lives = 3;
    _level = 0;
    _hits = 0;
    _playing = YES;
}

@end
