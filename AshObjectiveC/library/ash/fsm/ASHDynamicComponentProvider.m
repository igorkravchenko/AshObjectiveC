
#import "ASHDynamicComponentProvider.h"
#import <objc/message.h>

@implementation ASHDynamicComponentProvider
{
    id _target;
    SEL _closure;
}

- (id)initWithTarget:(id)target
             closure:(SEL)closure
{
    self = [super init];

    if (self != nil)
    {
        _target = target;
        _closure = closure;
    }

    return self;
}

- (id)getComponent
{
    return objc_msgSend(_target, _closure);
}

- (id)identifier
{
    return [NSStringFromSelector(_closure) stringByAppendingFormat:@"%ld", (unsigned long)[_target hash]];
}

@end