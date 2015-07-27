
#import "ASHListIteratingSystem.h"
#import <objc/message.h>

@implementation ASHListIteratingSystem

@synthesize nodeList;
@synthesize nodeClass;
@synthesize nodeUpdateTarget;
@synthesize nodeUpdateSelector;
@synthesize nodeAddedTarget;
@synthesize nodeAddedSelector;
@synthesize nodeRemovedTarget;
@synthesize nodeRemovedSelector;

- (id)initWithNodeClass:(Class)aNodeClass 
       nodeUpdateTarget:(id)aNodeUpdateTarget 
     nodeUpdateSelector:(SEL)aNodeUpdateSelector 
        nodeAddedTarget:(id)aNodeAddedTarget 
      nodeAddedSelector:(SEL)aNodeAddedSelector 
      nodeRemovedTarget:(id)aNodeRemovedTarget 
    nodeRemovedSelector:(SEL)aNodeRemovedSelector
{
    self = [super init];
    
    if(self != nil)
    {
        nodeClass = aNodeClass;
        nodeUpdateTarget = aNodeUpdateTarget;
        nodeUpdateSelector = aNodeUpdateSelector;
        nodeAddedTarget = aNodeAddedTarget;
        nodeAddedSelector = aNodeAddedSelector;
        nodeRemovedTarget = aNodeRemovedTarget;
        nodeAddedSelector = aNodeRemovedSelector;
    }
    
    return self;
}

- (id)initWithNodeClass:(Class)aNodeClass 
       nodeUpdateTarget:(id)aNodeUpdateTarget 
     nodeUpdateSelector:(SEL)aNodeUpdateSelector
{
    self = [super init];
    
    if(self != nil)
    {
        nodeClass = aNodeClass;
        nodeUpdateTarget = aNodeUpdateTarget;
        nodeUpdateSelector = aNodeUpdateSelector;
    }
    
    return self;
}

- (id)initWithNodeClass:(Class)aNodeClass
     nodeUpdateSelector:(SEL)aNodeUpdateSelector
      nodeAddedSelector:(SEL)aNodeAddedSelector
    nodeRemovedSelector:(SEL)aNodeRemovedSelector
{
    self = [super init];
    
    if(self != nil)
    {
        nodeClass = aNodeClass;
        nodeUpdateTarget = self;
        nodeUpdateSelector = aNodeUpdateSelector;
        nodeAddedTarget = self;
        nodeAddedSelector = aNodeAddedSelector;
        nodeRemovedTarget = self;
        nodeRemovedSelector = aNodeRemovedSelector;
    }
    
    return self;
}

- (id)initWithNodeClass:(Class)aNodeClass
     nodeUpdateSelector:(SEL)aNodeUpdateSelector
{
    self = [super init];
    
    if (self != nil)
    {
        nodeClass = aNodeClass;
        nodeUpdateTarget = self;
        nodeUpdateSelector = aNodeUpdateSelector;
    }
    
    return self;
}


- (void)addToEngine:(ASHEngine *)game
{
    nodeList = [game getNodeList:nodeClass];
    
    if(nodeAddedTarget != nil && nodeAddedSelector != nil)
    {
        for (ASHNode * node = nodeList->head; node != nil; node = node->next)
        {
            ((void(*)(id, SEL, id))objc_msgSend)(nodeAddedTarget, nodeAddedSelector, node);
        }
        
        [nodeList->nodeAdded addListener:nodeAddedTarget
                                  action:nodeAddedSelector];
    }
    
    if(nodeRemovedTarget != nil && nodeRemovedSelector != nil)
    {
        [nodeList->nodeRemoved addListener:nodeRemovedTarget
                                    action:nodeRemovedSelector];
    }
}

- (void)removeFromEngine:(ASHEngine *)game
{
    if(nodeAddedTarget != nil && nodeAddedSelector != nil)
    {
        [nodeList->nodeAdded removeListener:nodeAddedTarget
                                     action:nodeAddedSelector];
    }
    
    if(nodeRemovedTarget != nil && nodeRemovedSelector != nil)
    {
        [nodeList->nodeRemoved removeListener:nodeAddedTarget
                                       action:nodeAddedSelector];
    }
    
    nodeList = nil;
}

- (void)update:(double)time
{
    NSNumber * timeContainer = @(time);
    for (ASHNode * node = nodeList->head; node != nil; node = node->next)
    {
        ((void(*)(id, SEL, id, id))objc_msgSend)(nodeUpdateTarget, nodeUpdateSelector, node, timeContainer);
    }
}

@end
