
#import "CollisionSystem.h"
#import "SpaceshipCollisionNode.h"
#import "AsteroidCollisionNode.h"
#import "BulletCollisionNode.h"
#import "Audio.h"
#import "GameNode.h"

@implementation CollisionSystem
{
    __weak EntityCreator * creator;

    __weak ASHNodeList * games;
    __weak ASHNodeList * spaceships;
    __weak ASHNodeList * asteroids;
    __weak ASHNodeList * bullets;
}

- (id)initWithCreator:(EntityCreator *)aCreator
{
    self = [super init];
    
    if (self != nil)
    {
        creator = aCreator;
    }
    
    return self;
}

- (void)addToEngine:(ASHEngine *)engine
{
    games = [engine getNodeList:[GameNode class]];
    spaceships = [engine getNodeList:[SpaceshipCollisionNode class]];
    asteroids = [engine getNodeList:[AsteroidCollisionNode class]];
    bullets = [engine getNodeList:[BulletCollisionNode class]];
}

- (void)update:(double)time
{
    BulletCollisionNode * bullet = nil;
    AsteroidCollisionNode * asteroid = nil;
    SpaceshipCollisionNode * spaceship = nil;
    
    for (bullet = (BulletCollisionNode *)bullets->head;
         bullet != nil;
         bullet = (BulletCollisionNode *)bullet->next)
    {
        for (asteroid = (AsteroidCollisionNode *)asteroids->head;
             asteroid != nil;
             asteroid = (AsteroidCollisionNode *)asteroid->next)
        {
            float dx = asteroid.position.position.x - bullet.position.position.x;
            float dy = asteroid.position.position.y - bullet.position.position.y;
            float distSQ = sqrtf(dx * dx + dy * dy);
            if (distSQ < asteroid.collision.radius)
            {
                [creator destroyEntity:bullet->entity];
                if (asteroid.collision.radius > 10)
                {
                    [creator createAsteroidWithRadius:asteroid.collision.radius - 10
                                                    x:asteroid.position.position.x + MathRandom() * 10 - 5
                                                    y:asteroid.position.position.y + MathRandom() * 10 - 5];
                    [creator createAsteroidWithRadius:asteroid.collision.radius - 10
                                                    x:asteroid.position.position.x + MathRandom() * 10 - 5
                                                    y:asteroid.position.position.y + MathRandom() * 10 - 5];
                }

                [asteroid.asteroid.fsm changeState:@"destroyed"];
                [asteroid.audio play:ExplodeAsteroid];
                if( games->head )
                {
                    ((GameNode *)games->head).state.hits++;
                }

                break;
            }
        }
        
    }
    
    for (spaceship = (SpaceshipCollisionNode *)spaceships->head;
         spaceship != nil;
         spaceship = (SpaceshipCollisionNode *)spaceship->next)
    {
        for (asteroid = (AsteroidCollisionNode *)asteroids->head;
             asteroid != nil;
             asteroid = (AsteroidCollisionNode *)asteroid->next)
        {
            float dx = asteroid.position.position.x - spaceship.position.position.x;
            float dy = asteroid.position.position.y - spaceship.position.position.y;
            float distSQ = sqrtf(dx * dx + dy * dy);
            if (distSQ < asteroid.collision.radius + spaceship.collision.radius)
            {
                [spaceship.spaceship.fsm changeState:@"destroyed"];
                [spaceship.audio play:ExplodeShip];
                if(games->head)
                {
                    ((GameNode *)games->head).state.lives--;
                }
                break;
            }
        }
    }

}

- (void)removeFromEngine:(ASHEngine *)engine
{
    spaceships = nil;
    asteroids = nil;
    bullets = nil;
}

@end
