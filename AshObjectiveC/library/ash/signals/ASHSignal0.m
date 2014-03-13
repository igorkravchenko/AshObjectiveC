
#import "ASHSignal0.h"
#import <objc/message.h>

@implementation ASHSignal0

- (void)dispatch
{
    [super startDispatch];
    
    ASHListenerNode * node = nil;
    for (node = super.head; node != nil; node = node.next)
    {
        objc_msgSend(node.target, node.listener);

        if(node.once)
        {
            [super removeListener:node.target 
                           action:node.listener];
        }
    }
    
    [super endDispatch];
}

@end
