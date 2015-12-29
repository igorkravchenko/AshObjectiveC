
#import "ASHStateSystemMapping.h"
#import "ASHEngineState.h"
#import "ASHSystemProvider.h"
#import "ASHSystem.h"

@implementation ASHStateSystemMapping
{
    ASHEngineState * _creatingState;
    id <ASHSystemProvider> _provider;
}

- (instancetype __nonnull)initWithCreatingState:(ASHEngineState * __nonnull)creatingState
                             provider:(id <ASHSystemProvider> __nonnull)provider
{
    self = [super init];
    if (self)
    {
        _creatingState = creatingState;
        _provider = provider;
    }

    return self;
}

- (instancetype __nonnull)withPriority:(NSInteger)priority
{
    _provider.priority = priority;
    return self;
}

- (instancetype __nonnull)addInstance:(ASHSystem * __nonnull)system
{
    return [_creatingState addInstance:system];
}

- (instancetype __nonnull)addSingleton:(Class __nonnull)type
{
    return [_creatingState addSingleton:type];
}

- (instancetype __nonnull)addMethod:(id __nonnull)target
                   action:(SEL __nonnull)action
{
    return [_creatingState addMethod:target
                              action:action];
}

- (instancetype __nonnull)addProvider:(id <ASHSystemProvider> __nonnull)provider
{
    return [_creatingState addProvider:provider];
}


@end