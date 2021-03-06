
#import "ASHSignal0.h"
#import <objc/message.h>

@implementation ASHSignal0

- (void)dispatch
{
    [super startDispatch];
    
    ASHListenerNode * node = nil;
    for (node = head; node != nil; node = node->next)
    {
        ((void(*)(id, SEL))objc_msgSend)(node->target, node->listener);

        if(node->once)
        {
            [super removeListener:node->target
                           action:node->listener];
        }
    }
    
    [super endDispatch];
}

@end
