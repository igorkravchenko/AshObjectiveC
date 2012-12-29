
#import "ASHComponentInstanceProvider.h"

@implementation ASHComponentInstanceProvider
{
    id _instance;
}

- (id)initWithInstance:(id)instance
{
    self = [super init];
    
    if (self != nil)
    {
        _instance = instance;
    }
    
    return self;
}

- (id)getComponent
{
    return _instance;
}

- (id)identifier
{
    return _instance;
}
@end
