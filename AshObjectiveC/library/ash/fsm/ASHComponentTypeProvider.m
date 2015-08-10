
#import "ASHComponentTypeProvider.h"

@implementation ASHComponentTypeProvider
{
    Class componentType;
}

- (id)initWithType:(Class)type
{
    self = [super init];
    
    if (self != nil)
    {
        componentType = type;
    }
    
    return self;
}

- (id)getComponent
{
    return [[componentType alloc] init];
}

- (id)identifier
{
    return componentType;
}

@end
