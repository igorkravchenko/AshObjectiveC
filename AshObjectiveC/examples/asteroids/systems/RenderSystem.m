
#import "RenderSystem.h"
#import "RenderNode.h"

@implementation RenderSystem
{
    UIView * container;
    ASHNodeList * nodes;
}

- (id)initWithContainer:(UIView *)aContainer
{
    self = [super init];
    
    if (self != nil)
    {
        container = aContainer;
    }
    
    return self;
}

- (void)addToEngine:(ASHEngine *)engine
{
    nodes = [engine getNodeList:[RenderNode class]];
    for (RenderNode * node = (RenderNode *)nodes.head;
         node != nil;
         node = (RenderNode *)node.next)
    {
        [self addToDisplay:node];
    }
    [nodes.nodeAdded addListener:self
                          action:@selector(addToDisplay:)];
    [nodes.nodeRemoved addListener:self
                            action:@selector(removeFromDisplay:)];
}

- (void)addToDisplay:(RenderNode *)node
{
    [container addSubview:node.display.displayObject];
}

- (void)removeFromDisplay:(RenderNode *)node
{
    [node.display.displayObject removeFromSuperview];
}

- (void)update:(double)time
{
    RenderNode * node = nil;
    Position * position = nil;
    Display * display = nil;
    UIView * displayObject = nil;

    for (node = (RenderNode *)nodes.head;
         node != nil;
         node = (RenderNode *)node.next)
    {
        display = node.display;
        displayObject = display.displayObject;
        position = node.position;

        displayObject.transform = CGAffineTransformIdentity;
        displayObject.center = position.position;
        displayObject.transform = CGAffineTransformMakeRotation(position.rotation);
    }
}

- (void)removeFromEngine:(ASHEngine *)engine
{
    nodes = nil;
}

@end
