
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
        self.nodeClass = aNodeClass;
        self.nodeUpdateTarget = aNodeUpdateTarget;
        self.nodeUpdateSelector = aNodeUpdateSelector;
        self.nodeAddedTarget = aNodeAddedTarget;
        self.nodeAddedSelector = aNodeAddedSelector;
        self.nodeRemovedTarget = aNodeRemovedTarget;
        self.nodeAddedSelector = aNodeRemovedSelector;
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
        self.nodeClass = aNodeClass;
        self.nodeUpdateTarget = aNodeUpdateTarget;
        self.nodeUpdateSelector = aNodeUpdateSelector;
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
        self.nodeClass = aNodeClass;
        self.nodeUpdateTarget = self;
        self.nodeUpdateSelector = aNodeUpdateSelector;
        self.nodeAddedTarget = self;
        self.nodeAddedSelector = aNodeAddedSelector;
        self.nodeRemovedTarget = self;
        self.nodeRemovedSelector = aNodeRemovedSelector;
    }
    
    return self;
}

- (id)initWithNodeClass:(Class)aNodeClass
     nodeUpdateSelector:(SEL)aNodeUpdateSelector
{
    self = [super init];
    
    if (self != nil)
    {
        self.nodeClass = aNodeClass;
        self.nodeUpdateTarget = self;
        self.nodeUpdateSelector = aNodeUpdateSelector;
    }
    
    return self;
}


- (void)addToEngine:(ASHEngine *)game
{
    self.nodeList = [game getNodeList:self.nodeClass];
    
    if(nodeAddedTarget != nil && nodeAddedSelector != nil)
    {
        for (ASHNode * node = nodeList.head; node != nil; node = node.next)
        {
            objc_msgSend(nodeAddedTarget, nodeAddedSelector, node);
        }
        
        [nodeList.nodeAdded addListener:nodeAddedTarget 
                                 action:nodeAddedSelector];
    }
    
    if(nodeRemovedTarget != nil && nodeRemovedSelector != nil)
    {
        [nodeList.nodeRemoved addListener:nodeRemovedTarget 
                                   action:nodeRemovedSelector];
    }
}

- (void)removeFromEngine:(ASHEngine *)game
{
    if(nodeAddedTarget != nil && nodeAddedSelector != nil)
    {
        [nodeList.nodeAdded removeListener:nodeAddedTarget 
                                    action:nodeAddedSelector];
    }
    
    if(nodeRemovedTarget != nil && nodeRemovedSelector != nil)
    {
        [nodeList.nodeRemoved removeListener:nodeAddedTarget 
                                      action:nodeAddedSelector];
    }
    
    self.nodeList = nil;
}

- (void)update:(double)time
{
    NSNumber * timeContainer = @(time);
    for (ASHNode * node = nodeList.head; node != nil; node = node.next)
    {       
        objc_msgSend(nodeUpdateTarget, nodeUpdateSelector, node, timeContainer);
    }
}

@end
