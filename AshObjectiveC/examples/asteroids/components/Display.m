
#import "Display.h"

@implementation Display

- (instancetype)initWithDisplayObject:(UIView *)displayObject
{
    self = [super init];
    if (self)
    {
        _displayObject = displayObject;
    }

    return self;
}

@end
