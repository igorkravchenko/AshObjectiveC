#import "ASHStateComponentMapping.h"
#import "ASHEntityState.h"
#import "ASHComponentTypeProvider.h"
#import "ASHComponentSingletonProvider.h"
#import "ASHDynamicComponentProvider.h"

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

- (ASHStateComponentMapping *)withSingleton
{
    [self setProvider:[[ASHComponentSingletonProvider alloc] initWithType:componentType]];
    return self;
}

- (ASHStateComponentMapping *)withSingletonForType:(Class)type
{
    if(type == nil)
    {
        type = componentType;
    }

    [self setProvider:[[ASHComponentSingletonProvider alloc] initWithType:type]];
    return self;
}

- (ASHStateComponentMapping *)withTarget:(id)target
                                  method:(SEL)method
{
    [self setProvider:[[ASHDynamicComponentProvider alloc] initWithTarget:target
                                                                  closure:method]];
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
    [creatingState.providers setObject:provider forKey:componentType];
}

- (ASHStateComponentMapping *)add:(Class)type
{
    return [creatingState add:type];
}

@end
