
#import "ASHComponentInstanceProvider.h"

@implementation ASHComponentInstanceProvider
{
    id _instance;
}

- (instancetype __nonnull)initWithInstance:(id __nonnull)instance
{
    self = [super init];
    
    if (self != nil)
    {
        _instance = instance;
    }
    
    return self;
}

- (id __nonnull)getComponent
{
    return _instance;
}

- (id __nonnull)identifier
{
    return _instance;
}
@end
