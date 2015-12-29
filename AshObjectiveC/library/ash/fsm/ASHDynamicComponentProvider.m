
#import "ASHDynamicComponentProvider.h"
#import <objc/message.h>

@implementation ASHDynamicComponentProvider
{
    id _target;
    SEL _closure;
}

- (instancetype __nonnull)initWithTarget:(id __nonnull)target
             closure:(SEL __nonnull)closure
{
    self = [super init];

    if (self != nil)
    {
        _target = target;
        _closure = closure;
    }

    return self;
}

- (id __nonnull)getComponent
{
    return ((id(*)(id, SEL))objc_msgSend)(_target, _closure);
}

- (id __nonnull)identifier
{
    return [NSStringFromSelector(_closure) stringByAppendingFormat:@"%ld", (long)[_target hash]];
}

@end