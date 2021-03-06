#import <Foundation/Foundation.h>
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

- (void)addNode:(nonnull ASHNode *)node
{
    if(head == nil)
    {
        head = node;
        tail = node;
        node->next = nil;
        node->previous = nil;
    }
    else
    {
        tail->next = node;
        node->previous = tail;
        node->next = nil;
        tail = node;
    }
        
    [nodeAdded dispatchWithObject:node];
}

- (void)removeNode:(nonnull ASHNode *)node
{
    if(head == node)
    {
        head = head->next;
    }
    if(tail == node)
    {
        tail = tail->previous;
    }
    if(node->previous != nil)
    {
        node->previous->next = node->next;
    }
    if(node->next != nil)
    {
        node->next->previous = node->previous;
    }
    [nodeRemoved dispatchWithObject:node];
    // N.B. Don't set node.next and node.previous to null because that will break the list iteration if node is the current node in the iteration.

}

- (void)removeAll
{
    while (head != nil) 
    {
        ASHNode * node = head;
        head = node->next;
        node->previous = nil;
        node->next = nil;
        [nodeRemoved dispatchWithObject:node];
    }
    tail = nil;
}

- (BOOL)isEmpty
{
    return head == nil;
}

- (void)swapNode:(nonnull ASHNode *)node1
            node:(nonnull ASHNode *)node2
{
    if(node1->previous == node2)
    {
        node1->previous = node2->previous;
        node2->previous = node1;
        node2->next = node1->next;
        node1->next = node2;
    }
    else if(node2->previous == node1)
    {
        node2->previous = node1->previous;
        node1->previous = node2;
        node1->next = node2->next;
        node2->next = node1;
    }
    else
    {
        ASHNode * temp = node1->previous;
        node1->previous = node2->previous;
        node2->previous = temp;
        temp = node1->next;
        node1->next = node2->next;
        node2->next = temp;
    }
    if(head == node1)
    {
        head = node2;
    }
    else if(head == node2)
    {
        head = node1;
    }
    if(tail == node1)
    {
        tail = node2;
    }
    else if(tail == node2)
    {
        tail = node1;
    }
    
    if(node1->previous != nil)
    {
        node1->previous->next = node1;
    }
    if(node2->previous != nil)
    {
        node2->previous->next = node2;
    }
    if(node1->next != nil)
    {
        node1->next->previous = node1;
    }
    if(node2->next != nil)
    {
        node2->next->previous = node2;
    }
}

- (void)insertionSortUsingBlock:(float (^__nonnull)(ASHNode * __nonnull, ASHNode * __nonnull))sortBlock;
{
    if (head == tail)
    {
        return;
    }

    ASHNode * remains = head->next;
    for (ASHNode * node = remains; node != nil; node = remains)
    {
        remains = node->next;
        ASHNode * other = nil;
        for (other = node->previous; other != nil; other = other->previous)
        {
            if (sortBlock(node, other) >= 0.f)
            {
                if (node != other->next)
                {
                    if (tail == node)
                    {
                        tail = node->previous;
                    }
                    node->previous->next = node->next;
                    if (node->next != nil)
                    {
                        node->next->previous = node->previous;
                    }

                    node->next = other->next;
                    node->previous = other;
                    node->next->previous = node;
                    other->next = node;
                }
                break;
            }
        }
        if (other == nil)
        {
            if (tail == node)
            {
                tail = node->previous;
            }
            node->previous->next = node->next;
            if (node->next != nil)
            {
                node->next->previous = node->previous;
            }

            node->next = head;
            head->previous = node;
            node->previous = nil;
            head = node;
        }
    }
}

- (void)mergeSortUsingBlock:(float (^__nonnull)(ASHNode * __nonnull, ASHNode * __nonnull))sortBlock
{
    if (head == tail)
    {
        return;
    }
    NSMutableArray * lists = [NSMutableArray array];

    ASHNode * start = head;
    ASHNode * end = nil;
    while (start != nil)
    {
        end = start;
        while (end->next != nil && sortBlock(end, end->next) <= 0.f)
        {
            end = end->next;
        }
        ASHNode * next = end->next;
        start->previous = end->next = nil;
        [lists addObject:start];
        start = next;
    }

    while (lists.count > 1)
    {
        ASHNode * h1 = lists[0];
        [lists removeObjectAtIndex:0];
        ASHNode * h2 = lists[0];
        [lists removeObjectAtIndex:0];

        [lists addObject:[self mergeHead1:h1
                                    head2:h2
                                sortBlock:sortBlock]];
    }

    tail = head = lists[0];
    while (tail->next != nil)
    {
        tail = tail->next;
    }
}

- (ASHNode *)mergeHead1:(ASHNode *)head1
                  head2:(ASHNode *)head2
              sortBlock:(float (^)(ASHNode *, ASHNode *))sortBlock
{
    ASHNode * node = nil;
    ASHNode * headNode = nil;
    if (sortBlock(head1, head2) <= 0.f)
    {
        headNode = node = head1;
        head1 = head1->next;
    }
    else
    {
        headNode = node = head2;
        head2 = head2->next;
    }
    while (head1 != nil && head2 != nil)
    {
        if (sortBlock(head1, head2) <= 0)
        {
            node->next = head1;
            head1->previous = node;
            node = head1;
            head1 = head1->next;
        }
        else
        {
            node->next = head2;
            head2->previous = node;
            node = head2;
            head2 = head2->next;
        }
    }
    if (head1 != nil)
    {
        node->next = head1;
        head1->previous = node;
    }
    else
    {
        node->next = head2;
        head2->previous = node;
    }
    return headNode;
}

#pragma mark - Fast Enumeration
// http://supertommy.me/content/2013/implementing-nsfastenumeration/
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained[])buffer
                                    count:(NSUInteger)len
{
    if(state->state == 0)
    {
        state->mutationsPtr = &state->extra[0]; //unused
        state->state = 1;
        state->extra[1] = (unsigned long)head;  //this is used to save position in the list; start with head node
    }

    NSUInteger count = 0;
    state->itemsPtr = buffer;

    //grab the current start node
    void * n = (void*)state->extra[1];  //these casts to avoid ARC retain operations
    ASHNode * node = (__bridge ASHNode *)n;

    //node is nil if the list is exhausted
    while(node)
    {
        buffer[count] = node;
        ++count;

        if(count < len)
        {
            //continue if there's still room
            node = node->next;
        }
        else
        {
            //break if we run out of room in the buffer
            break;
        }
    }

    //node may be nil at this point but ObjC returns nil on messages sent to nil
    //save the next start node which is nil if the list is exhausted
    state->extra[1] = (unsigned long)node.next;
    return count;
}

@end