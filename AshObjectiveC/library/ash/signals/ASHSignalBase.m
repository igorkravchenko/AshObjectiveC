
#import "ASHSignalBase.h"
#import "ASHListenerNodePool.h"
#import "ASHListenerNode.h"

#define GET_TARGET_ACTION_KEY(object, selector) [NSString stringWithFormat:@"%@%ld", NSStringFromSelector(selector), (long)[(NSObject *)object hash]]

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
        _numListeners = 0;
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
            head = toAddHead;
            tail = toAddTail;
        }
        else
        {
            tail->next = toAddHead;
            toAddHead->previous = tail;
            tail = toAddTail;
        }
        
        toAddHead = nil;
        toAddTail = nil;
    }
    [listenerNodePool releaseCache];
}

- (void)addListener:(id)target 
             action:(SEL)action
{
    NSString * const key = GET_TARGET_ACTION_KEY(target, action);
    if (nodes[key] != nil)
    {
        return;
    }
    
    ASHListenerNode * node = [listenerNodePool get];
    node->target = target;
    node->listener = action;
    nodes[key] = node;
    [self addNode:node];
}

- (void)addListenerOnce:(id)target 
                 action:(SEL)action
{
    NSString * const key = GET_TARGET_ACTION_KEY(target, action);
    if(nodes[key] != nil)
    {
        return;
    }
    
    ASHListenerNode * node = [listenerNodePool get];
    node->target = target;
    node->listener = action;
    node->once = YES;
    nodes[key] = node;
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
            toAddTail->next = node;
            node->previous = toAddTail;
            toAddTail = node;
        }
    }
    else
    {
        if(head == nil)
        {
            head = node;
            tail = node;
        }
        else
        {
            tail->next = node;
            node->previous = tail;
            tail = node;
        }
    }
    _numListeners++;
}

- (void)removeListener:(id)target 
                action:(SEL)action
{
    NSString * const listenerKey = GET_TARGET_ACTION_KEY(target, action);
    
    ASHListenerNode * node = nodes[listenerKey];
        
    if(node != nil)
    {
        if(head == node)
        {
            head = head->next;
        }
        
        if(tail == node)
        {
            tail = tail->previous;
        }
        
        if(toAddHead == node)
        {
            toAddHead = toAddHead->next;
        }
        
        if(toAddTail == node)
        {
            toAddTail = toAddTail->previous;
        }
        
        if(node->previous != nil)
        {
            node->previous->next = node->next;
        }
        
        if (node->next != nil)
        {
            node->next->previous = node->previous;
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
        _numListeners--;
    }
}

- (void)removeAll
{
    while (head != nil) 
    {
        ASHListenerNode * node = head;
        head = head->next;
        [nodes removeObjectForKey:GET_TARGET_ACTION_KEY(node->target, node->listener)];
        [listenerNodePool dispose:node];
    }
    tail = nil;
    toAddHead = nil;
    toAddTail = nil;
    _numListeners = 0;
}

@end
