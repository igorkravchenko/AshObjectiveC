
#import "ASHSystemInstanceProvider.h"
#import "ASHSystem.h"

@implementation ASHSystemInstanceProvider
{
    ASHSystem * _instance;
    NSInteger _systemPriority;
}

- (instancetype)initWithInstance:(ASHSystem *)instance
{
    self = [super init];
    if (self)
    {
        _instance = instance;
        _systemPriority = 0;
    }

    return self;
}


- (ASHSystem *)getSystem
{
    return _instance;
}

- (id)identifier
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