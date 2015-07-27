//
// Created by Igor Kravchenko on 7/20/15.
// Copyright (c) 2015 Igor Kravchenko. All rights reserved.
//

#import "WaitForStart.h"
#import "WaitForStartView.h"
#import "ASHSignal0.h"

@implementation WaitForStart
{

}

- (void)setStartGame
{
    _startGame = YES;
}

- (instancetype)initWithWaitForStart:(WaitForStartView *)waitForStart
{
    self = [super init];
    if (self)
    {
        _waitForStart = waitForStart;
        [waitForStart.click addListener:self
                                 action:@selector(setStartGame)];
    }

    return self;
}


@end