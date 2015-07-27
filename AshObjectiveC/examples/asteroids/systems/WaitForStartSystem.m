//
// Created by Igor Kravchenko on 7/22/15.
// Copyright (c) 2015 Igor Kravchenko. All rights reserved.
//

#import "WaitForStartSystem.h"
#import "EntityCreator.h"
#import "WaitForStartNode.h"
#import "GameNode.h"
#import "AsteroidCollisionNode.h"
#import "WaitForStart.h"


@implementation WaitForStartSystem
{
    __weak ASHEngine * engine;
    __weak EntityCreator * creator;

    __weak ASHNodeList * gameNodes;
    __weak ASHNodeList * waitNodes;
    __weak ASHNodeList * asteroids;
}

- (instancetype)initWithCreator:(EntityCreator *)aCreator
{
    self = [super init];
    if (self)
    {
        creator = aCreator;
    }

    return self;
}

- (void)addToEngine:(ASHEngine *)anEngine
{
    engine = anEngine;
    waitNodes = [engine getNodeList:WaitForStartNode .class];
    gameNodes = [engine getNodeList:GameNode.class];
    asteroids = [engine getNodeList:AsteroidCollisionNode.class];
}

- (void)update:(double)time
{
    WaitForStartNode * node = (WaitForStartNode *) waitNodes->head;
    GameNode * game = (GameNode *) gameNodes->head;

    if(node && node.wait.startGame && game)
    {
        for (AsteroidCollisionNode * asteroid = (AsteroidCollisionNode *) asteroids->head; asteroid; asteroid = (AsteroidCollisionNode *) asteroid->next)
        {
            [creator destroyEntity:asteroid->entity];
        }

        [game.state setForStart];
        node.wait.startGame = NO;
        [engine removeEntity:node->entity];
    }
}

- (void)removeFromEngine:(ASHEngine *)anEngine
{
    gameNodes = nil;
    waitNodes = nil;
}


@end