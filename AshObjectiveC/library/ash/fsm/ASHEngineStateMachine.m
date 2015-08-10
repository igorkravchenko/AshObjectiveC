//
// Created by Igor Kravchenko on 2/21/14.
// Copyright (c) 2014 Igor Kravchenko. All rights reserved.
//

#import "ASHEngineStateMachine.h"
#import "ASHEngine.h"
#import "ASHEngineState.h"
#import "ASHSystemProvider.h"


@implementation ASHEngineStateMachine
{
    NSMapTable * _states;
    ASHEngineState * _currentState;

}

- (instancetype)initWithEngine:(ASHEngine *)engine
{
    self = [super init];
    if (self)
    {
        self.engine = engine;
        _states = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsStrongMemory];
    }

    return self;
}

- (ASHEngineStateMachine *)addState:(NSString *)name
                              state:(ASHEngineState *)state
{
    [_states setObject:state forKey:name];
    return self;
}

- (ASHEngineState *)createState:(NSString *)name
{
    ASHEngineState * state = [[ASHEngineState alloc] init];
    [_states setObject:state forKey:name];
    return state;
}

- (void)changeState:(NSString *)name
{
    ASHEngineState * newState = [_states objectForKey:name];
    if(newState == nil)
    {
        @throw [NSException exceptionWithName:@"ASHEngineStateMachineException"
                                       reason:[NSString stringWithFormat:@"Engine state %@ doesn't exist", name]
                                     userInfo:nil];
    }

    if(newState == _currentState)
    {
        newState = nil;
        return;
    }

    NSMapTable * toAdd;
    id <ASHSystemProvider> provider;
    id iD;
    toAdd = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsStrongMemory];

    for (provider in newState.providers)
    {
        iD = provider.identifier;
        [toAdd setObject:provider forKey:iD];
    }

    if(_currentState)
    {
        for (provider in _currentState.providers)
        {
            iD = provider.identifier;
            id <ASHSystemProvider> other = [toAdd objectForKey:iD];
            if(other)
            {
                [toAdd removeObjectForKey:iD];
            }
            else
            {
                [_engine removeSystem:[provider getSystem]];
            }
        }
    }

    for (id providerKey in toAdd)
    {
        provider = [toAdd objectForKey:providerKey];
        [_engine addSystem:[provider getSystem]
                  priority:provider.priority];
    }

    _currentState = newState;
}


@end