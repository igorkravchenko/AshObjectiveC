
#import "BulletView.h"

@implementation BulletView

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        CAShapeLayer * layer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddEllipseInRect(path, NULL, CGRectMake(-2, -2, 4, 4));
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.path = path;
        [super.layer addSublayer:layer];
        CGPathRelease(path);
    }
    
    return self;
}

@end
