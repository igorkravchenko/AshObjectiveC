
#import <objc/message.h>
#import "ASHDynamicSystemProvider.h"
#import "ASHSystem.h"

@implementation ASHDynamicSystemProvider
{
    id _target;
    SEL _method;
    NSInteger _systemPriority;
}

- (instancetype)initWithTarget:(id)target
                        method:(SEL)method
{
    self = [super init];

    if(self)
    {
        _target = target;
        _method = method;
    }

    return self;
}

- (ASHSystem *)getSystem
{
    return ((id(*)(id, SEL))objc_msgSend)(_target, _method);
}

- (id)identifier
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