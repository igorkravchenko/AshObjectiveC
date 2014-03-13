
#import "MockRectangle.h"

@implementation MockRectangle
{
}

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    self = [super init];
    if (self)
    {
        self.x = x;
        self.y = y;
        self.width = width;
        self.height = height;
    }

    return self;
}

+ (instancetype)rectangleWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    return [[self alloc] initWithX:x y:y width:width height:height];
}


@end