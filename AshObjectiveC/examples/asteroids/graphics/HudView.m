
#import "HudView.h"

@implementation HudView
{
    __weak UILabel * _score;
    __weak UILabel * _lives;
    CGSize _size;
}

- (instancetype)initWithSize:(CGSize)screenSize
{
    self = [super init];
    if (self)
    {
        _size = screenSize;
        UILabel * score = [self createTextField];
        _score = score;
        [super addSubview:_score];

        UILabel * lives = [self createTextField];
        _lives = lives;
        CGRect livesRect = _lives.frame;
        livesRect.origin.x = 0;
        livesRect.origin.y = 5;
        _lives.frame = livesRect;

        [super addSubview:_lives];

        [self setScore:0];
        [self setLives:3];
    }

    return self;
}

- (void)setScore:(NSInteger)value
{
    _score.text = [NSString stringWithFormat:@"SCORE: %li", (long)value];
    [_score sizeToFit];
    CGRect screenRect = CGRectMake(0, 0, _size.width, _size.height);
    CGPoint position = CGPointMake(CGRectGetMaxX(screenRect) - CGRectGetWidth(_score.frame), 5);
    CGRect scoreRect = _score.frame;
    scoreRect.origin = position;
    _score.frame = scoreRect;
}

- (void)setLives:(NSInteger)value
{
    _lives.text = [NSString stringWithFormat:@"LIVES: %li", (long)value];
    [_lives sizeToFit];
}

- (UILabel *)createTextField
{
    UILabel * label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold"
                                 size:18];
    return label;
}

@end