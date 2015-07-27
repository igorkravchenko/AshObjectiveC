
#import "MotionControlSystem.h"
#import "MotionControlNode.h"

@implementation MotionControlSystem
{
    TriggerPoll * triggerPoll;
}

- (id)initWithTriggerPoll:(TriggerPoll *)aTriggerPoll
{
    self = [super initWithNodeClass:[MotionControlNode class]
                 nodeUpdateSelector:@selector(updateNode:time:)];
    if (self != nil)
    {
        triggerPoll = aTriggerPoll;
    }
    
    return self;
}

- (void)updateNode:(MotionControlNode *)node
              time:(NSNumber *)time
{
    MotionControls * control = node.control;
    Position * position = node.position;
    Motion * motion = node.motion;

    if([triggerPoll isActive:(Trigger) control.left])
    {
        position.rotation -= control.rotationRate * time.doubleValue;
    }
    
    if ([triggerPoll isActive:(Trigger) control.right])
    {
        position.rotation += control.rotationRate * time.doubleValue;
    }

    if([triggerPoll isActive:(Trigger) control.accelerate])
    {
        CGPoint velocity = motion.velocity;
        velocity.x += cos(position.rotation) * control.accelerationRate * time.doubleValue;
        velocity.y += sin(position.rotation) * control.accelerationRate * time.doubleValue;
        motion.velocity = velocity;
    }
}

@end
