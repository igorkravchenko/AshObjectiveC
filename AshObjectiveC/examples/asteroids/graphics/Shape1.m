
#import "Shape1.h"

@implementation Shape1

- (id)initView
{
    self = [super initWithFrame:CGRectZero];
    
    if (self != nil)
    {
        self.bounds = CGRectMake(-10, -10, 20, 20);
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
    CGContextAddLineToPoint(context, 10, 0);
    CGContextFillPath(context);
}

@end
