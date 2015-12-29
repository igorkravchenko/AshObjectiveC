
#import "ASHEntityState.h"
#import "ASHStateComponentMapping.h"

@implementation ASHEntityState

- (instancetype __nonnull)init
{
    self = [super init];
    
    if (self != nil)
    {
        _providers = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaquePersonality valueOptions:NSPointerFunctionsStrongMemory];
    }
    
    return self;
}

- (ASHStateComponentMapping * __nonnull)add:(Class __nonnull)type
{
    return [[ASHStateComponentMapping alloc] initWithCreatingState:self
                                                              type:type];
}


- (id <ASHComponentProvider> __nonnull)get:(Class __nonnull)type
{
    return [_providers objectForKey:type];
}

- (BOOL)has:(Class __nonnull)type
{
    return [_providers objectForKey:type] != nil;
}

@end
