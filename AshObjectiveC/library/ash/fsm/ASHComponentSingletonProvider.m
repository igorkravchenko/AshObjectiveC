
#import "ASHComponentSingletonProvider.h"

@implementation ASHComponentSingletonProvider
{
    Class componentType;
    id instance;
}

- (instancetype __nonnull)initWithType:(Class __nonnull)type
{
    self = [super init];
    
    if (self != nil)
    {
        componentType = type;
    }
    
    return self;
}

- (id __nonnull)getComponent
{
    if(instance == nil)
    {
        instance = [[componentType alloc] init];
    }
    
    return instance;
}

- (id __nonnull)identifier
{
    return [self getComponent];
}

@end
