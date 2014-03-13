
#import "ASHSystemSingletonProvider.h"
#import "ASHSystem.h"

@implementation ASHSystemSingletonProvider
{
    Class _componentType;
    ASHSystem * _instance;
    NSInteger _systemPriority;
}

- (instancetype)initWithComponentType:(Class)componentType
{
    self = [super init];
    if (self)
    {
        _componentType = componentType;
    }

    return self;
}


- (ASHSystem *)getSystem
{
    if(!_instance)
    {
        _instance = [[_componentType alloc] init];
    }

    return _instance;
}

- (id)identifier
{
    return [self getSystem];
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