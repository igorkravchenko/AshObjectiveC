
#import "WaitForStartView.h"
#import "ASHSignal0.h"

@implementation WaitForStartView
{
    __weak UILabel * gameOver;
    __weak UILabel * clickToStart;
    CGSize size;
}

- (instancetype)initWithSize:(CGSize)screenSize
{
    self = [super initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    if (self)
    {
        size = screenSize;
        _click = [[ASHSignal0 alloc] init];
        UILabel * gameOverLabel = [self createGameOver];
        [super addSubview:gameOverLabel];
        gameOver = gameOverLabel;
        UILabel * clickToStartLabel = [self createClickToStart];
        [super addSubview:clickToStartLabel];
        clickToStart = clickToStartLabel;
        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(dispatchClick)];
        [super addGestureRecognizer:tapGestureRecognizer];
    }

    return self;
}


- (UILabel *)createGameOver
{
    UILabel * tf = [[UILabel alloc] init];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.font = [UIFont fontWithName:@"Helvetica-Bold"
                              size:32];
    tf.textColor = [UIColor whiteColor];
    tf.text = @"ASTEROIDS";
    [tf sizeToFit];

    CGRect screenRect = CGRectMake(0, 0, size.width, size.height);
    tf.center = CGPointMake(CGRectGetMidX(screenRect), CGRectGetMidY(screenRect) - 25);

    return tf;
}

- (void)dispatchClick
{
    [_click dispatch];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    gameOver.text = @"GAME OVER";
    [gameOver sizeToFit];
}

- (UILabel *)createClickToStart
{
    UILabel * tf = [[UILabel alloc] init];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.font = [UIFont fontWithName:@"Helvetica-Bold"
                              size:18];
    tf.textColor = [UIColor whiteColor];
    tf.text =  @"CLICK TO START";
    [tf sizeToFit];

    CGRect screenRect = CGRectMake(0, 0, size.width, size.height);
    tf.center = CGPointMake(CGRectGetMidX(screenRect), CGRectGetMidY(screenRect) + 25);

    return tf;
}

@end