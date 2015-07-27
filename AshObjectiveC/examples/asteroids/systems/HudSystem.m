//
// Created by Igor Kravchenko on 7/22/15.
// Copyright (c) 2015 Igor Kravchenko. All rights reserved.
//

#import "HudSystem.h"
#import "HudNode.h"
#import "Hud.h"
#import "HudView.h"
#import "GameState.h"


@implementation HudSystem
{

}

- (instancetype)init
{
    self = [super initWithNodeClass:HudNode.class
                 nodeUpdateSelector:@selector(updateNode:time:)];
    if (self)
    {

    }

    return self;
}

- (void)updateNode:(HudNode *)node
              time:(double)time
{
    [node.hud.view setLives:node.state.lives];
    [node.hud.view setScore:node.state.hits];
}


@end