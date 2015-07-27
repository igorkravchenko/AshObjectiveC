
#import "Shape2.h"

@implementation Shape2

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        CAShapeLayer * layer = [CAShapeLayer layer];
        [super.layer addSublayer:layer];
        CGMutablePathRef path = CGPathCreateMutable();

        CGPathMoveToPoint   (path, NULL, 10, 0);
        CGPathAddLineToPoint(path, NULL, -7, -7);
        CGPathAddLineToPoint(path, NULL, -4, 0);
        CGPathAddLineToPoint(path, NULL, 10, 0);

        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.path = path;
        CGPathRelease(path);
    }
    
    return self;
}

@end
