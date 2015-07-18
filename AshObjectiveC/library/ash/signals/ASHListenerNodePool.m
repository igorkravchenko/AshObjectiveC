
#import "ASHListenerNodePool.h"

@implementation ASHListenerNodePool
{
    ASHListenerNode * tail;
    ASHListenerNode * cacheTail;
}

- (ASHListenerNode *)get
{
    if(tail != nil)
    {
        ASHListenerNode * node = tail;
        tail = tail->previous;
        node->previous = nil;
        return node;
    }
    else
    {
        return [[ASHListenerNode alloc] init];
    }
}

- (void)dispose:(ASHListenerNode *)node
{
    node->listener = nil;
    node->target = nil;
    node->once = NO;
    node->next = nil;
    node->previous = tail;
    tail = node;
}

- (void)cache:(ASHListenerNode *)node
{
    node->listener = nil;
    node->target = nil;
    node->previous = cacheTail;
    cacheTail = node;
}

- (void)releaseCache
{
    while (cacheTail != nil) 
    {
        ASHListenerNode * node = cacheTail;
        cacheTail = node->previous;
        node->next = nil;
        node->previous = tail;
        tail = node;
    }
}

@end
