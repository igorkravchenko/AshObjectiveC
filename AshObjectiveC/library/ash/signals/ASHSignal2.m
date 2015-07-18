
#import "ASHSignal2.h"
#import <objc/message.h>

@implementation ASHSignal2

- (void)dispatchWithObject:(id)object1 
                withObject:(id)object2
{
    [super startDispatch];
   
    ASHListenerNode * node = nil;
    for (node = head; node != nil; node = node->next)
    {
        ((void(*)(id, SEL, id, id))objc_msgSend)(node->target, node->listener, object1, object2);

        if(node->once)
        {
            [super removeListener:node->target
                           action:node->listener];
        }
    }
    [super endDispatch];
}

@end
