
#import "AnimationSystem.h"
#import "AnimationNode.h"

@implementation AnimationSystem

- (id)init
{
    self = [super initWithNodeClass:[AnimationNode class]
                 nodeUpdateSelector:@selector(updateNode:time:)];
    
    if (self != nil)
    {
        
    }
    
    return self;
}

- (void)updateNode:(AnimationNode *)node
              time:(NSNumber *)time
{
    [node.animation.animation animate:time.doubleValue];
}

@end
