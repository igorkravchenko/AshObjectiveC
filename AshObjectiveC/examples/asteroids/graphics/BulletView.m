
#import "BulletView.h"

@implementation BulletView

- (id)initBullet
{
    self = [super initWithFrame:CGRectZero];
    
    if (self != nil)
    {
        self.bounds = CGRectMake(-2, -2, 4, 4);
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddEllipseInRect(context, self.bounds);
    CGContextFillPath(context);
}

@end
