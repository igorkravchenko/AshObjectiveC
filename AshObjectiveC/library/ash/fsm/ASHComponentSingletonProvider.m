
#import "ASHComponentSingletonProvider.h"

@implementation ASHComponentSingletonProvider
{
    Class componentType;
    id instance;
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
    if(instance == nil)
    {
        instance = [[componentType alloc] init];
    }
    
    return instance;
}

- (id)identifier
{
    return [self getComponent];
}

@end
