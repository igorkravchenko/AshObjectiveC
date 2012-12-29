
#import "ASHEntityStateMachine.h"
#import "ASHEntityState.h"
#import "ASHEntity.h"

@implementation ASHEntityStateMachine
{
    NSMutableDictionary * states;
    ASHEntityState * currentState;
    ASHEntity * entity;
}

- (id)initWithEntity:(ASHEntity *)anEntity
{
    self = [super init];
    
    if (self != nil)
    {
        entity = anEntity;
        states = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (ASHEntityStateMachine *)addState:(NSString *)name
                           state:(ASHEntityState *)state
{
    states[name] = state;
    return self;
}

- (ASHEntityState *)createState:(NSString *)name
{
    ASHEntityState * state = [[ASHEntityState alloc] init];
    states[name] = state;
    return state;
}

- (void)changeState:(NSString *)name
{
    ASHEntityState * newState = states[name];
    if (states == nil)
    {
        @throw [NSException exceptionWithName:@"EntityStateMachineException"
                                       reason:[NSString stringWithFormat:@"ASHEntity state %@ doesn't exist", name]
                                     userInfo:nil];
    }
    if (newState == currentState)
    {
        newState = nil;
        return;
    }
    
    NSMutableDictionary * toAdd = nil;
    NSString * type = nil;
    id t = nil;
    
    if (currentState != nil)
    {
        toAdd = [NSMutableDictionary dictionary];
        for (t in newState.providers)
        {
            type = t;
            toAdd[type] = newState.providers[type];
        }
        for (t in currentState.providers)
        {
            type = t;
            id <ASHComponentProvider> other = toAdd[type];
            
            if (other != nil && other.identifier == [(id <ASHComponentProvider>)currentState.providers[type] identifier])
            {
                [toAdd removeObjectForKey:type];
            }
            else
            {
                [entity removeComponent:NSClassFromString(type)];
            }
        }
    }
    else
    {
        toAdd = newState.providers;
    }

    for (t in toAdd)
    {
        type = t;
        [entity addComponent:[toAdd[type] getComponent]
               componentClass:NSClassFromString(type)];
    }
    
    currentState = newState;
}

@end
