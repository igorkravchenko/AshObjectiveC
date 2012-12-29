
#import "ASHSignalBase.h"
#import "ASHListenerNodePool.h"
#import "ASHListenerNode.h"

#define GET_TARGET_ACTION_KEY(object, selector) [NSString stringWithFormat:@"%@%u", NSStringFromSelector(selector), [(NSObject *)object hash]]

@implementation ASHSignalBase
{
    NSMutableDictionary * nodes;
    ASHListenerNodePool * listenerNodePool;
    ASHListenerNode * toAddHead;
    ASHListenerNode * toAddTail;
    BOOL dispatching;
}

@synthesize head;
@synthesize tail;



- (id)init
{
    self = [super init];
    
    if(self != nil)
    {
        nodes = [NSMutableDictionary dictionary];
        listenerNodePool = [[ASHListenerNodePool alloc] init];
    }
    
    return self;
}

- (void)startDispatch
{
    dispatching = YES;
}

- (void)endDispatch
{
    dispatching = NO;
    
    if(toAddHead != nil)
    {
        if(head == nil)
        {
            self.head = toAddHead;
            self.tail = toAddTail;
        }
        else
        {
            tail.next = toAddHead;
            toAddHead.previous = tail;
            self.tail = toAddTail;
        }
        
        toAddHead = nil;
        toAddTail = nil;
    }
    [listenerNodePool releaseCache];
}

- (void)addListener:(id)target 
             action:(SEL)action
{
    if ([nodes objectForKey:GET_TARGET_ACTION_KEY(target, action)] != nil) 
    {
        return;
    }
    
    ASHListenerNode * node = [listenerNodePool get];
    node.target = target;
    node.listener = action;
    [nodes setObject:node 
              forKey:GET_TARGET_ACTION_KEY(target, action)];
    [self addNode:node];
}

- (void)addListenerOnce:(id)target 
                 action:(SEL)action
{
    if([nodes objectForKey:GET_TARGET_ACTION_KEY(target, action)] != nil)
    {
        return;
    }
    
    ASHListenerNode * node = [listenerNodePool get];
    node.target = target;
    node.listener = action;
    node.once = YES;
    [nodes setObject:node 
              forKey:GET_TARGET_ACTION_KEY(target, action)];
    [self addNode:node];
}

- (void)addNode:(ASHListenerNode *)node
{
    if (dispatching) 
    {
        if(toAddHead == nil)
        {
            toAddHead = node;
            toAddTail = node;
        }
        else
        {
            toAddTail.next = node;
            node.previous = toAddTail;
            toAddTail = node;
        }
    }
    else
    {
        if(head == nil)
        {
            self.head = node;
            self.tail = node;
        }
        else
        {
            tail.next = node;
            node.previous = tail;
            self.tail = node;
        }
    }
}

- (void)removeListener:(id)target 
                action:(SEL)action
{
    NSString * listenerKey = GET_TARGET_ACTION_KEY(target, action);
    
    ASHListenerNode * node = [nodes objectForKey:listenerKey];
        
    if(node != nil)
    {
        if(head == node)
        {
            self.head = head.next;
        }
        
        if(tail == node)
        {
            self.tail = tail.previous;
        }
        
        if(toAddHead == node)
        {
            toAddHead = toAddHead.next;
        }
        
        if(toAddTail == node)
        {
            toAddTail = toAddTail.previous;
        }
        
        if(node.previous != nil)
        {
            node.previous.next = node.next;
        }
        
        if (node.next != nil) 
        {
            node.next.previous = node.previous;
        }
                
        [nodes removeObjectForKey:listenerKey];
        
        if(dispatching)
        {
            [listenerNodePool cache:node];
        }
        else 
        {
            [listenerNodePool dispose:node];
        } 
    }
}

- (void)removeAll
{
    while (head != nil) 
    {
        ASHListenerNode * listener = head;
        self.head = head.next;
        listener.previous = nil;
        listener.next = nil;
    }
    self.tail = nil;
    toAddHead = nil;
    toAddTail = nil;
}

@end
