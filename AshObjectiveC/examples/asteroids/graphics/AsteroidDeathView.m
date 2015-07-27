//
// Created by Igor Kravchenko on 7/20/15.
// Copyright (c) 2015 Igor Kravchenko. All rights reserved.
//

#import "AsteroidDeathView.h"

@interface Dot : NSObject

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, strong) CALayer * image;

- (instancetype)initWithMaxDistance:(float)maxDistance;

@end

@implementation AsteroidDeathView
{
    NSArray * _dots;
}

static NSInteger const numDots = 8;


- (instancetype)initWithRadius:(float)radius
{
    self = [super init];

    if (self)
    {
        NSMutableArray * dots = [NSMutableArray arrayWithCapacity:numDots];
        for (int i = 0; i < numDots; ++i)
        {
            Dot * dot = [[Dot alloc] initWithMaxDistance:radius];
            [super.layer addSublayer:dot.image];
            [dots addObject:dot];
        }
        _dots = dots;
    }

    return self;
}

- (void)animate:(double)time
{
    for (Dot * dot in _dots)
    {
        CGPoint p = dot.image.position;
        p.x += dot.velocity.x * time;
        p.y += dot.velocity.y * time;
        dot.image.position = p;
    }
}

@end


@implementation Dot

- (instancetype)initWithMaxDistance:(float)maxDistance
{
    self = [super init];

    if (self)
    {
        CAShapeLayer * image = [CAShapeLayer layer];
        _image = image;
        CGMutablePathRef path = CGPathCreateMutable();
        image.fillColor = UIColor.whiteColor.CGColor;
        CGPathAddEllipseInRect(path, NULL, CGRectMake(-0.5f, -0.5f, 1, 1));
        image.path = path;
        CGPathRelease(path);
        float angle = MathRandom() * 2.f * (float)M_PI;
        float distance = MathRandom() * maxDistance;
        CGPoint p = CGPointMake( cosf( angle ) * distance, sinf( angle ) * distance );
        image.position = p;
        float speed = MathRandom() * 10.f + 10.f;
        _velocity = CGPointMake(cosf( angle ) * speed, sinf( angle ) * speed);
    }

    return self;
}

@end