
#import "GameManager.h"
#import "GameNode.h"
#import "SpaceshipNode.h"
#import "GameNode.h"
#import "AsteroidCollisionNode.h"
#import "BulletCollisionNode.h"

@implementation GameManager
{
    GameConfig * config;
    EntityCreator * creator;
    
    ASHNodeList * gameNodes;
    ASHNodeList * spaceships;
    ASHNodeList * asteroids;
    ASHNodeList * bullets;
}

- (id)initWithCreator:(EntityCreator *)aCreator
               config:(GameConfig *)aConfig
{
    self = [super init];
    
    if (self != nil)
    {
        creator = aCreator;
        config = aConfig;
    }
    
    return self;
}

- (void)addToEngine:(ASHEngine *)engine
{
    gameNodes = [engine getNodeList:[GameNode class]];
    spaceships = [engine getNodeList:[SpaceshipNode class]];
    asteroids = [engine getNodeList:[AsteroidCollisionNode class]];
    bullets = [engine getNodeList:[BulletCollisionNode class]];
}

- (void)update:(double)time
{
    GameNode * node = nil;
    for (node = (GameNode *)gameNodes.head;
         node != nil;
         node = (GameNode *)node.next)
    {
        if ([spaceships isEmpty])
        {
            if (node.state.lives > 0)
            {
                CGPoint newSpaceshipPosition = CGPointMake(config.width * 0.5,
                                                           config.height * 0.5);
                BOOL clearToAddSpaceship = YES;
                for (AsteroidCollisionNode * asteroid = (AsteroidCollisionNode *)asteroids.head; asteroid != nil;
                     asteroid = (AsteroidCollisionNode *)asteroid.next)
                {
                    float dx = asteroid.position.position.x - newSpaceshipPosition.x;
                    float dy = asteroid.position.position.y - newSpaceshipPosition.y;
                    float distSQ = sqrtf(dx * dx + dy * dy);
                    
                    if (distSQ <= asteroid.collision.radius + 50)
                    {
                        clearToAddSpaceship = NO;
                        break;
                    }
                }
                
                if (clearToAddSpaceship)
                {
                    [creator createSpaceship];
                    node.state.lives--;
                }
            }
            else
            {
                // game over
                NSLog(@"%@", @"game over");
            }
        }
        
        if ([asteroids isEmpty] && [bullets isEmpty] && ![spaceships isEmpty])
        {
            // next level
            SpaceshipNode * spaceship = (SpaceshipNode *)spaceships.head;
            node.state.level++;
            NSInteger asteroidCount = 2 + node.state.level;
            for (NSInteger i = 0; i < asteroidCount; ++i)
            {
                // check not on top of spaceship
                CGPoint position;
                
                do {
                    position = CGPointMake(MathRandom() * config.width, MathRandom() * config.height);
                } while (sqrtf(
                               powf(position.x - spaceship.position.position.x, 2) +
                               powf(position.y - spaceship.position.position.y, 2)) <= 80.f);
                [creator createAsteroidWithRadius:30
                                                x:position.x
                                                y:position.y];
            }
        }
    }
}

- (void)removeFromEngine:(ASHEngine *)engine
{
    gameNodes = nil;
    spaceships = nil;
    asteroids = nil;
    bullets = nil;
}

@end
