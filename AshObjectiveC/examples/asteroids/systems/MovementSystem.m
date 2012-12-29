
#import "MovementSystem.h"
#import "MovementNode.h"

@implementation MovementSystem
{
    GameConfig * config;
}

- (id)initWithConfig:(GameConfig *)aConfig
{
    self = [super initWithNodeClass:[MovementNode class]
                 nodeUpdateSelector:@selector(updateNode:time:)];
    
    if (self != nil)
    {
        config = aConfig;
    }
    
    return self;
}

- (void)updateNode:(MovementNode *)node
              time:(NSNumber *)time
{
    Position * position = node.position;
    Motion * motion = node.motion;
    
    CGPoint positionPoint = position.position;
    positionPoint.x += motion.velocity.x * time.doubleValue;
    positionPoint.y += motion.velocity.y * time.doubleValue;
    
    if(positionPoint.x < 0)
    {
        positionPoint.x += config.width;
    }
    
    if (positionPoint.x > config.width)
    {
        positionPoint.x -= config.width;
    }
    
    if (positionPoint.y < 0)
    {
        positionPoint.y += config.height;
    }
    
    if (positionPoint.y > config.height)
    {
        positionPoint.y -= config.height;
    }
    
    position.position = positionPoint;
    position.rotation += motion.angularVelocity * time.doubleValue;
    
    if (motion.damping > 0)
    {
        double xDamp = fabs( cosf(position.rotation) * motion.damping * time.doubleValue );
        double yDamp = fabs( cosf(position.rotation) * motion.damping * time.doubleValue );
        CGPoint velocity = motion.velocity;
       
        if (velocity.x > xDamp)
        {
            velocity.x -= xDamp;
        }
        else if (velocity.x < -xDamp)
        {
            velocity.x += xDamp;
        }
        else
        {
            velocity.x = 0;
        }
        
        if (velocity.y > yDamp)
        {
            velocity.y -= yDamp;
        }
        else if(velocity.y < -yDamp)
        {
            velocity.y += yDamp;
        }
        else
        {
            velocity.y = 0;
        }
        
        motion.velocity = velocity;
    }
    
}

@end
