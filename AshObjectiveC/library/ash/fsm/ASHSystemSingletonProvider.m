
#import "ASHSystemSingletonProvider.h"
#import "ASHSystem.h"

@implementation ASHSystemSingletonProvider
{
    Class _componentType;
    ASHSystem * _instance;
    NSInteger _systemPriority;
}

- (instancetype __nonnull)initWithComponentType:(Class __nonnull)componentType
{
    self = [super init];
    if (self)
    {
        _componentType = componentType;
    }

    return self;
}


- (ASHSystem * __nonnull)getSystem
{
    if(!_instance)
    {
        _instance = (ASHSystem *) [[_componentType alloc] init];
    }

    return _instance;
}

- (id __nonnull)identifier
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