#import "ASHEngineState.h"
#import "ASHStateSystemMapping.h"
#import "ASHSystem.h"
#import "ASHSystemProvider.h"
#import "ASHSystemInstanceProvider.h"
#import "ASHSystemSingletonProvider.h"
#import "ASHDynamicSystemProvider.h"

@implementation ASHEngineState
{
}

- (instancetype __nonnull)init
{
    self = [super init];
    if (self)
    {
        _providers = [NSMutableArray array];
    }

    return self;
}


- (ASHStateSystemMapping * __nonnull)addInstance:(ASHSystem * __nonnull)system
{
    return [self addProvider:[[ASHSystemInstanceProvider alloc] initWithInstance:system]];
}

- (ASHStateSystemMapping * __nonnull)addSingleton:(Class __nonnull)aClass
{
    return [self addProvider:[[ASHSystemSingletonProvider alloc] initWithComponentType:aClass]];
}

- (ASHStateSystemMapping * __nonnull)addMethod:(id __nonnull)target
                              action:(SEL __nonnull)action
{
    return [self addProvider:[[ASHDynamicSystemProvider alloc] initWithTarget:target
                                                                       method:action]];
}

- (ASHStateSystemMapping * __nonnull)addProvider:(id <ASHSystemProvider> __nonnull)provider
{
    ASHStateSystemMapping * mapping = [[ASHStateSystemMapping alloc] initWithCreatingState:self
                                                                                  provider:provider];
    [_providers addObject:provider];
    return mapping;
}

@end










