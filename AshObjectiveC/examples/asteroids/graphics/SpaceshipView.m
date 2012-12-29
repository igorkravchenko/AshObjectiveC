
#import "SpaceshipView.h"

@implementation SpaceshipView

- (id)initSpaceship
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.bounds = CGRectMake(-7, -7, 17, 14);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 10, 0);
    CGContextAddLineToPoint(context, -7, 7);
    CGContextAddLineToPoint(context, -4, 0);
    CGContextAddLineToPoint(context, -7, -7);
    CGContextAddLineToPoint(context, 10, 0);
    CGContextFillPath(context);
}

@end
