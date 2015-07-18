
#import "ASHSignalAny.h"

@implementation ASHSignalAny

- (void)dispatchWithObjects:(id)object, ...
{
    [super startDispatch];
    ASHListenerNode * node = nil;
    NSNull * null = [NSNull null];
    for (node = head; node != nil; node = node->next)
    {
        NSMethodSignature * methodSignature = [node->target methodSignatureForSelector:node->listener];
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        
        invocation.target = node->target;
        invocation.selector = node->listener;
        
        NSInteger i = 2;
        
        if(object != null)
        {
            [invocation setArgument:&object
                            atIndex:i];
        }
        
        i++;
        
        va_list args;
        va_start(args, object);
        id nextObject = nil;
        while((nextObject = va_arg(args, id)))
        {
            if(nextObject != null)
            {
                [invocation setArgument:&nextObject
                                atIndex:i];
            }
            
            i++;
        }
        va_end(args);
        
        [invocation invoke];
        
        if(node->once)
        {
            [super removeListener:node->target
                           action:node->listener];
        }
    }
    
    [super endDispatch];
}

@end
