
#import "ASHEntityList.h"

@implementation ASHEntityList

@synthesize head;
@synthesize tail;

- (void)addEntity:(ASHEntity *)entity
{
    if(head == nil)
    {
        head = entity;
        tail = entity;
        entity->next = nil;
        entity->previous = nil;
    }
    else
    {
        tail->next = entity;
        entity->previous = tail;
        entity->next = nil;
        tail = entity;
    }
}

- (void)removeEntity:(ASHEntity *)entity
{
    if(head == entity)
    {
        head = head->next;
    }
    if(tail == entity)
    {
        tail = tail->previous;
    }
    
    if(entity->previous != nil)
    {
        entity->previous->next = entity->next;
    }
    
    if(entity->next != nil)
    {
        entity->next->previous = entity->previous;
    }

    // N.B. Don't set entity.next and entity.previous to null because that will break the list iteration if node is the current node in the iteration.
}

- (void)removeAll
{
    while (head != nil) 
    {
        ASHEntity * entity = head;
        head = head->next;
        entity->previous = nil;
        entity->next = nil;
    }
    
    tail = nil;
}

@end