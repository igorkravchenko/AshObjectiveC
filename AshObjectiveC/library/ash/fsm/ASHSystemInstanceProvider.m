
#import "ASHSystemInstanceProvider.h"
#import "ASHSystem.h"

@implementation ASHSystemInstanceProvider
{
    ASHSystem * _instance;
    NSInteger _systemPriority;
}

- (instancetype __nonnull)initWithInstance:(ASHSystem * __nonnull)instance
{
    self = [super init];
    if (self)
    {
        _instance = instance;
        _systemPriority = 0;
    }

    return self;
}


- (ASHSystem * __nonnull)getSystem
{
    return _instance;
}

- (id __nonnull)identifier
{
    return @(_instance.hash);
}

- (NSInteger)priority
{
    return _systemPriority;
}

- (void)setPriority:(NSInteger)value
{
    _systemPriority = value;
}


@end