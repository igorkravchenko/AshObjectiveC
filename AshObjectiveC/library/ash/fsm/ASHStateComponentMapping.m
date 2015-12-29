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

- (instancetype __nonnull)initWithCreatingState:(ASHEntityState * __nonnull)aCreatingState
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

- (ASHStateComponentMapping * __nonnull)withInstance:(id __nonnull)component
{
    [self setProvider:[[ASHComponentInstanceProvider alloc] initWithInstance:component]];
    return self;
}

- (ASHStateComponentMapping * __nonnull)withType:(Class __nonnull)type
{
    [self setProvider:[[ASHComponentTypeProvider alloc] initWithType:type]];
    return self;
}

- (ASHStateComponentMapping * __nonnull)withSingleton
{
    [self setProvider:[[ASHComponentSingletonProvider alloc] initWithType:componentType]];
    return self;
}

- (ASHStateComponentMapping * __nonnull)withSingletonForType:(Class __nonnull)type
{
    if(type == nil)
    {
        type = componentType;
    }

    [self setProvider:[[ASHComponentSingletonProvider alloc] initWithType:type]];
    return self;
}

- (ASHStateComponentMapping * __nonnull)withTarget:(id __nonnull)target
                                  method:(SEL __nonnull)method
{
    [self setProvider:[[ASHDynamicComponentProvider alloc] initWithTarget:target
                                                                  closure:method]];
    return self;
}

- (ASHStateComponentMapping * __nonnull)withProvider:(id<ASHComponentProvider> __nonnull)aProvider
{
    [self setProvider:aProvider];
    return self;
}

- (void)setProvider:(id<ASHComponentProvider> __nonnull)aProvider
{
    provider = aProvider;
    [creatingState.providers setObject:provider forKey:componentType];
}

- (ASHStateComponentMapping * __nonnull)add:(Class __nonnull)type
{
    return [creatingState add:type];
}

@end
