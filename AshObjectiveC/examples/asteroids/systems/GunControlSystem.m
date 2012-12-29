
#import "GunControlSystem.h"
#import "GunControlNode.h"

@implementation GunControlSystem
{
    TriggerPoll * triggerPoll;
    EntityCreator * creator;
}
- (id)initWithTriggerPoll:(TriggerPoll *)aTriggerPoll
                  creator:(EntityCreator *)aCreator
{
    self = [super initWithNodeClass:[GunControlNode class]
                 nodeUpdateSelector:@selector(updateNode:time:)];
    
    if (self != nil)
    {
        triggerPoll = aTriggerPoll;
        creator = aCreator;
    }
    
    return self;
}

- (void)updateNode:(GunControlNode *)node
              time:(NSNumber *)time
{
    GunControls * control = node.control;
    Position * position = node.position;
    Gun * gun = node.gun;
    
    gun.shooting = [triggerPoll isActive:control.trigger];
    gun.timeSinceLastShot += time.doubleValue;
    if(gun.shooting && gun.timeSinceLastShot >= gun.minimumShotInterval)
    {

        [creator createUserBullet:gun
                   parentPosition:position];
        gun.timeSinceLastShot = 0;
    }
}

@end
