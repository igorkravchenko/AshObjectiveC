
#import "ASHEntityState.h"
#import "ASHStateComponentMapping.h"

@implementation ASHEntityState

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _providers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (ASHStateComponentMapping *)add:(Class)type
{
    return [[ASHStateComponentMapping alloc] initWithCreatingState:self
                                                           type:type];
}


- (id <ASHComponentProvider>)get:(Class)type
{
    return _providers[NSStringFromClass(type)];
}

- (BOOL)has:(Class)type
{
    return _providers[NSStringFromClass(type)] != nil;
}

@end
