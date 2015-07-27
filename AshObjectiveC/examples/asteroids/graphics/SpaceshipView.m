
#import "SpaceshipView.h"

@implementation SpaceshipView

- (id)init
{
    self = [super init];

    if (self)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 10, 0);
        CGPathAddLineToPoint(path, NULL, -7, 7);
        CGPathAddLineToPoint(path, NULL, -4, 0);
        CGPathAddLineToPoint(path, NULL, -7, -7);
        CGPathAddLineToPoint(path, NULL, 10, 0);
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.path = path;
        CGPathRelease(path);
        [super.layer addSublayer:layer];
    }

    return self;
}

@end
