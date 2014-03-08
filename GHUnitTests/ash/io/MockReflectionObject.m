
#import "MockReflectionObject.h"

@implementation MockReflectionObject
{
    NSInteger _fullAccessor;
}

- (NSInteger)fullAccessor
{
    return _fullAccessor;
}

- (void)setFullAccessor:(NSInteger)fullAccessor
{
    _fullAccessor = fullAccessor;
}

- (NSInteger)getOnlyAccessor
{
    return 1;
}

- (void)setOnlyAccessor:(NSInteger)value;
{

}


@end