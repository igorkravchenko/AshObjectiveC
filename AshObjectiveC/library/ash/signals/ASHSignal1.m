
#import "ASHSignal1.h"
#import <objc/message.h>

@implementation ASHSignal1

- (void)dispatchWithObject:(id)object
{
    [super startDispatch];
    
    ASHListenerNode * node = nil;
    
    for (node = super.head; node != nil; node = node.next) 
    {
        ((void(*)(id, SEL, id))objc_msgSend)(node.target, node.listener, object);
        
        if(node.once)
        {
            [super removeListener:node.target 
                           action:node.listener];
        }
    }
    
    [super endDispatch];
}

@end
