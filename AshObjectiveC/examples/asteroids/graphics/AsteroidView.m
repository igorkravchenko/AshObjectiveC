
#import "AsteroidView.h"

@implementation AsteroidView
{
}

- (id)initWithRadius:(float)radius
{
    self = [super init];
    
    if (self != nil)
    {
        float angle = 0;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, radius, 0);
        while (angle < M_PI * 2)
        {
            float length = (0.75f + MathRandom() * 0.25f) * radius;
            float posX = cosf(angle) * length;
            float posY = sinf(angle) * length;
            CGPathAddLineToPoint(path, NULL, posX, posY);
            angle += MathRandom() * 0.5;
        }
        CGPathAddLineToPoint(path, NULL, radius, 0);
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.path = path;
        [super.layer addSublayer:layer];
        CGPathRelease(path);
    }
    
    return self;
}

@end
