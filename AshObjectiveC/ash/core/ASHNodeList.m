
#import "ASHNodeList.h"

@implementation ASHNodeList
@synthesize head;
@synthesize tail;
@synthesize nodeAdded;
@synthesize nodeRemoved;

- (id)init
{
    self = [super init];
    
    if(self != nil)
    {
        nodeAdded = [[ASHSignal1 alloc] init];
        nodeRemoved = [[ASHSignal1 alloc] init];
    }
    
    return self;
}

- (void)addNode:(ASHNode *)node
{
    if(head == nil)
    {
        self.head = node;
        self.tail = node;
        node.next = nil;
        node.previous = nil;
    }
    else
    {
        tail.next = node;
        node.previous = tail;
        node.next = nil;
        self.tail = node;
    }
        
    [nodeAdded dispatchWithObject:node];
}

- (void)removeNode:(ASHNode *)node
{
    if(head == node)
    {
        self.head = head.next;
    }
    if(tail == node)
    {
        self.tail = tail.previous;
    }
    if(node.previous != nil)
    {
        node.previous.next = node.next;
    }
    if(node.next != nil)
    {
        node.next.previous = node.previous;
    }
    [nodeRemoved dispatchWithObject:node];
    // N.B. Don't set node.next and node.previous to null because that will break the list iteration if node is the current node in the iteration.

}

- (void)removeAll
{
    while (head != nil) 
    {
        ASHNode * node = head;
        self.head = node.next;
        node.previous = nil;
        node.next = nil;
        [nodeRemoved dispatchWithObject:node];
    }
    self.tail = nil;
}

- (BOOL)isEmpty
{
    return head == nil;
}

- (void)swapNode:(ASHNode *)node1
            node:(ASHNode *)node2
{
    if(node1.previous == node2)
    {
        node1.previous = node2.previous;
        node2.previous = node1;
        node2.next = node1.next;
        node1.next = node2;
    }
    else if(node2.previous == node1) 
    {
        node2.previous = node1.previous;
        node1.previous = node2;
        node1.next = node2.next;
        node2.next = node1;
    }
    else
    {
        ASHNode * temp = node1.previous;
        node1.previous = node2.previous;
        node2.previous = temp;
        temp = node1.next;
        node1.next = node2.next;
        node2.next = temp;
    }
    if(head == node1)
    {
        self.head = node2;
    }
    else if(head == node2)
    {
        self.head = node1;
    }
    if(tail == node1)
    {
        self.tail = node2;
    }
    else if(tail == node2)
    {
        self.tail = node1;
    }
    
    if(node1.previous != nil)
    {
        node1.previous.next = node1;
    }
    if(node2.previous != nil)
    {
        node2.previous.next = node2;
    }
    if(node1.next != nil)
    {
        node1.next.previous = node1;
    }
    if(node2.next != nil)
    {
        node2.next.previous = node2;
    }
}

@end