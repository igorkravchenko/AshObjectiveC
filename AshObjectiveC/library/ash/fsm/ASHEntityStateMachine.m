
#import "ASHEntityStateMachine.h"
#import "ASHEntityState.h"
#import "ASHEntity.h"

@implementation ASHEntityStateMachine
{
    NSMapTable * states;
    ASHEntityState * currentState;
    ASHEntity * entity;
}

- (instancetype __nonnull)initWithEntity:(ASHEntity * __nonnull)anEntity
{
    self = [super init];
    
    if (self != nil)
    {
        entity = anEntity;
        states = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsStrongMemory];
    }
    
    return self;
}

- (ASHEntityStateMachine * __nonnull)addState:(NSString * __nonnull)name
                           state:(ASHEntityState * __nonnull)state
{
    [states setObject:state forKey:name];
    return self;
}

- (ASHEntityState * __nonnull)createState:(NSString * __nonnull)name
{
    ASHEntityState * state = [[ASHEntityState alloc] init];
    [states setObject:state forKey:name];
    return state;
}

- (void)changeState:(NSString * __nonnull)name
{
    ASHEntityState * newState = [states objectForKey:name];
    if (newState == nil)
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

    NSMapTable * toAdd = nil;
    Class type = nil;
    id t = nil;
    
    if (currentState != nil)
    {
        toAdd = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsStrongMemory];
        for (t in newState.providers)
        {
            type = t;
            [toAdd setObject:[newState.providers objectForKey:type] forKey:type];
        }
        for (t in currentState.providers)
        {
            type = t;
            id <ASHComponentProvider> other = [toAdd objectForKey:type];
            
            if (other != nil && other.identifier == [(id <ASHComponentProvider>)[currentState.providers objectForKey:type] identifier])
            {
                [toAdd removeObjectForKey:type];
            }
            else
            {
                [entity removeComponent:type];
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
        [entity addComponent:[[toAdd objectForKey:type] getComponent]
                componentClass:type];
    }
    
    currentState = newState;
}

@end
