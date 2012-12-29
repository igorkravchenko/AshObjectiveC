
#import "SpaceshipDeathView.h"
#import "Shape1.h"
#import "Shape2.h"

@implementation SpaceshipDeathView
{
    Shape1 * shape1;
    Shape2 * shape2;
    CGPoint vel1;
    CGPoint vel2;
    float rot1;
    float rot2;
    float angle1;
    float angle2;

}

- (id)initView
{
    self = [super initWithFrame:CGRectZero];
    
    if (self)
    {
        shape1 = [[Shape1 alloc] initView];
        [self addSubview:shape1];
        shape2 = [[Shape2 alloc] initView];
        [self addSubview:shape2];
        vel1 = CGPointMake(MathRandom() * 10. - 5., MathRandom() * 10 + 10);
        vel2 = CGPointMake(MathRandom() * 10. - 5., -(MathRandom() * 10 + 10));
        
        rot1 = MathRandom() * 300 - 150;
        rot2 = MathRandom() * 300 - 150;

        angle1 = 0.f;
        angle2 = 0.f;
    }
    
    return self;
}

- (void)animate:(double)time
{
    CGPoint pos1 = shape1.center;
    pos1.x += vel1.x * time;
    pos1.y += vel1.y * time;
    shape1.center = pos1;
    shape1.transform = CGAffineTransformMakeRotation(angle1);
    angle1 += rot1 * M_PI / 180. * time;

    CGPoint pos2 = shape2.center;
    pos2.x += vel2.x * time;
    pos2.y += vel2.y * time;
    shape2.center = pos2;
    shape2.transform = CGAffineTransformMakeRotation(angle2);
    angle2 += rot2 * M_PI / 180. * time;
}

@end
