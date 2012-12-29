
#import "GameState.h"

@implementation GameState

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _lives = 3;
        _level = 0;
        _points = 0;
    }
    
    return self;
}

@end
