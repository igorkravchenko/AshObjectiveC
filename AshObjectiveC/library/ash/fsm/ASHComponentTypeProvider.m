
#import "ASHComponentTypeProvider.h"

@implementation ASHComponentTypeProvider
{
    Class componentType;
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
    return [[componentType alloc] init];
}

- (id __nonnull)identifier
{
    return componentType;
}

@end
