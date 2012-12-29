
#import "ASHStateComponentMapping.h"
#import "ASHEntityState.h"
#import "ASHComponentProvider.h"
#import "ASHComponentTypeProvider.h"
#import "ASHComponentSingletonProvider.h"

@implementation ASHStateComponentMapping
{
Class componentType;
    ASHEntityState * creatingState;
    id <ASHComponentProvider> provider;
}

- (id)initWithCreatingState:(ASHEntityState *)aCreatingState
                       type:(Class)type
{
    self = [super init];
    
    if (self != nil)
    {
        creatingState = aCreatingState;
        componentType = type;
        [self withType:type];
    }
    
    return self;
}

- (ASHStateComponentMapping *)withInstance:(id)component
{
    [self setProvider:[[ASHComponentInstanceProvider alloc] initWithInstance:component]];
    return self;
}

- (ASHStateComponentMapping *)withType:(Class)type
{
    [self setProvider:[[ASHComponentTypeProvider alloc] initWithType:type]];
    return self;
}

- (ASHStateComponentMapping *)withSingletonForType:(Class)type
{
    [self setProvider:[[ASHComponentSingletonProvider alloc] initWithType:type]];
    return self;
}

- (ASHStateComponentMapping *)withProvider:(id<ASHComponentProvider>)aProvider
{
    [self setProvider:aProvider];
    return self;
}

- (void)setProvider:(id<ASHComponentProvider>)aProvider
{
    provider = aProvider;
    creatingState.providers[NSStringFromClass(componentType)] = provider;
}

- (ASHStateComponentMapping *)add:(Class)type
{
    return [creatingState add:type];
}

@end
