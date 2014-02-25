
#import "ASHStateSystemMapping.h"
#import "ASHEngineState.h"
#import "ASHSystemProvider.h"
#import "ASHSystem.h"

@implementation ASHStateSystemMapping
{
    ASHEngineState * _creatingState;
    id <ASHSystemProvider> _provider;
}

- (instancetype)initWithCreatingState:(ASHEngineState *)creatingState
                             provider:(id <ASHSystemProvider>)provider
{
    self = [super init];
    if (self)
    {
        _creatingState = creatingState;
        _provider = provider;
    }

    return self;
}

- (instancetype)withPriority:(NSInteger)priority
{
    _provider.priority = priority;
    return self;
}

- (instancetype)addInstance:(ASHSystem *)system
{
    return [_creatingState addInstance:system];
}

- (instancetype)addSingleton:(Class)type
{
    return [_creatingState addSingleton:type];
}

- (instancetype)addMethod:(id)target
                   action:(SEL)action
{
    return [_creatingState addMethod:target
                              action:action];
}

- (instancetype)addProvider:(id <ASHSystemProvider>)provider
{
    return [_creatingState addProvider:provider];
}


@end