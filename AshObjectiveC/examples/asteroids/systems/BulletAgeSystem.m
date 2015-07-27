
#import "BulletAgeSystem.h"
#import "BulletAgeNode.h"

@implementation BulletAgeSystem
{
    EntityCreator * creator;
}

- (id)initWithCreator:(EntityCreator *)aCreator
{
    self = [super initWithNodeClass:[BulletAgeNode class]
                 nodeUpdateSelector:@selector(updateNode:time:)];
    
    if (self != nil)
    {
        creator = aCreator;
    }
    
    return self;
}

- (void)updateNode:(BulletAgeNode *)node
              time:(NSNumber *)time
{
    Bullet * bullet = node.bullet;
    bullet.lifeRemaining -= time.floatValue;
    if (bullet.lifeRemaining <= 0.)
    {
        [creator destroyEntity:node->entity];
    }
}

@end
