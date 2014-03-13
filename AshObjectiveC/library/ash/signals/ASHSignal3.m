
#import "ASHSignal3.h"
#import <objc/message.h>

@implementation ASHSignal3

- (void)dispatchWithObject:(id)anObject1 
                withObject:(id)anObject2 
                withObject:(id)anObject3
{
    [super startDispatch];
    ASHListenerNode * node = nil;
    for (node = super.head; node != nil; node = node.next) 
    {
        objc_msgSend(node.target, node.listener, anObject1, anObject2, anObject3);
        if(node.once)
        {
            [super removeListener:node.target 
                           action:node.listener];
        }
    }
    [super endDispatch];
}

@end
