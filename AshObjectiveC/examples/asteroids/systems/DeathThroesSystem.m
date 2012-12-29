
#import "DeathThroesSystem.h"
#import "DeathThroesNode.h"

@implementation DeathThroesSystem
{
    EntityCreator * creator;
}

- (id)initEntityCreator:(EntityCreator *)aCreator
{
    self = [super initWithNodeClass:[DeathThroesNode class]
                 nodeUpdateSelector:@selector(updateNode:time:)];
    
    if (self != nil)
    {
        creator = aCreator;
    }
    
    return self;
}

- (void)updateNode:(DeathThroesNode *)node
              time:(NSNumber *)time
{
    node.death.countdown -= time.doubleValue;
    if (node.death.countdown <= 0)
    {
        [creator destroyEntity:node.entity];
    }
}

@end
