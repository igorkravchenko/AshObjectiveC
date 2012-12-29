
#import "AsteroidView.h"

@implementation AsteroidView
{
    float _radius;
}

- (id)initWithRadius:(float)radius
{
    self = [super initWithFrame:CGRectZero];
    
    if (self != nil)
    {
        _radius = radius;
        self.backgroundColor = [UIColor clearColor];
        self.bounds = CGRectMake(-radius, -radius, radius * 2, radius * 2);
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float angle = 0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, _radius, 0);
    while (angle < M_PI * 2)
    {
        float length = (0.75 + MathRandom() * 0.25) * _radius;
        float posX = cosf(angle) * length;
        float posY = sinf(angle) * length;
        CGContextAddLineToPoint(context, posX, posY);
        angle += MathRandom() * 0.5;
    }
    CGContextAddLineToPoint(context, _radius, 0);
    CGContextFillPath(context);
}

@end
