#import "ASHEngineState.h"
#import "ASHStateSystemMapping.h"
#import "ASHSystem.h"
#import "ASHSystemProvider.h"
#import "ASHSystemInstanceProvider.h"
#import "ASHSystemSingletonProvider.h"
#import "ASHDynamicComponentProvider.h"
#import "ASHDynamicSystemProvider.h"

@implementation ASHEngineState
{
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _providers = [NSMutableArray array];
    }

    return self;
}


- (ASHStateSystemMapping *)addInstance:(ASHSystem *)system
{
    return [self addProvider:[[ASHSystemInstanceProvider alloc] initWithInstance:system]];
}

- (ASHStateSystemMapping *)addSingleton:(Class)aClass
{
    return [self addProvider:[[ASHSystemSingletonProvider alloc] initWithComponentType:aClass]];
}

- (ASHStateSystemMapping *)addMethod:(id)target
                              action:(SEL)action
{
    return [self addProvider:[[ASHDynamicSystemProvider alloc] initWithTarget:target
                                                                       method:action]];
}

- (ASHStateSystemMapping *)addProvider:(id <ASHSystemProvider>)provider
{
    ASHStateSystemMapping * mapping = [[ASHStateSystemMapping alloc] initWithCreatingState:self
                                                                                  provider:provider];
    [_providers addObject:provider];
    return mapping;
}

@end










