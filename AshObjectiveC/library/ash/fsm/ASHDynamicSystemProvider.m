
#import <objc/message.h>
#import "ASHDynamicSystemProvider.h"
#import "ASHSystem.h"

@implementation ASHDynamicSystemProvider
{
    id _target;
    SEL _method;
    NSInteger _systemPriority;
}

- (instancetype __nonnull)initWithTarget:(id __nonnull)target
                        method:(SEL __nonnull)method
{
    self = [super init];

    if(self)
    {
        _target = target;
        _method = method;
    }

    return self;
}

- (ASHSystem * __nonnull)getSystem
{
    return ((id(*)(id, SEL))objc_msgSend)(_target, _method);
}

- (id __nonnull)identifier
{
    return [NSStringFromSelector(_method) stringByAppendingFormat:@"%ld", (long)[_target hash]];
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