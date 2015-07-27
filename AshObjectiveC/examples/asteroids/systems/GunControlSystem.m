
#import "GunControlSystem.h"
#import "GunControlNode.h"
#import "Audio.h"

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
    
    gun.shooting = [triggerPoll isActive:(Trigger) control.trigger];
    gun.timeSinceLastShot += time.floatValue;
    if(gun.shooting && gun.timeSinceLastShot >= gun.minimumShotInterval)
    {

        [creator createUserBullet:gun
                   parentPosition:position];
        [node.audio play:ShootGun];
        gun.timeSinceLastShot = 0;
    }
}

@end
