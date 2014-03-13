
#import "ASHSystemList.h"

@implementation ASHSystemList

@synthesize head;
@synthesize tail;

- (void)addSystem:(ASHSystem *)system
{
    if(head == nil)
    {
        self.head = system;
        self.tail = system;
        system.next = nil;
        system.previous = nil;
    }
    else
    {
        ASHSystem * node = nil;
        
        for (node = tail; node != nil; node = node.previous) 
        {
            if(node.priority <= system.priority)
            {
                break;
            }
        }
        
        if(node == tail)
        {
            tail.next = system;
            system.previous = tail;
            system.next = nil;
            self.tail = system;
        }
        else if(node == nil)
        {
            system.next = head;
            system.previous = nil;
            head.previous = system;
            self.head = system;
        }
        else
        {
            system.next = node.next;
            system.previous = node;
            node.next.previous = system;
            node.next = system;
        }
    }
}

- (void)removeSystem:(ASHSystem *)system
{
    if(head == system)
    {
        self.head = head.next;
    }
    
    if(tail == system)
    {
        self.tail = tail.previous;
    }
    
    if(system.previous != nil)
    {
        system.previous.next = system.next;
    }
    
    if(system.next != nil)
    {
        system.next.previous = system.previous;
    }
    
    // N.B. Don't set system.next and system.previous to null because that will break the list iteration if node is the current node in the iteration.
}

- (void)removeAll
{
    while (head != nil) 
    {
        ASHSystem * system = head;
        self.head = head.next;
        system.previous = nil;
        system.next = nil;
    }
    self.tail = nil;
}

- (ASHSystem *)getSystem:(Class)type
{
    ASHSystem * system = nil;
    
    for (system = head; system != nil; system = system.next) 
    {
        if([system class] == type)
        {
            return system;
        }
    }
    
    return nil;
}

@end
