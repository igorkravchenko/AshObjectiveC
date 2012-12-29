
#import "EntityCreator.h"
#import "GameState.h"
#import "Asteroid.h"
#import "Position.h"
#import "Collision.h"
#import "Motion.h"
#import "Display.h"
#import "AsteroidView.h"
#import "ASHEntityStateMachine.h"
#import "MotionControls.h"
#import "ASHStateComponentMapping.h"
#import "Gun.h"
#import "GunControls.h"
#import "Trigger.h"
#import "SpaceshipView.h"
#import "SpaceshipDeathView.h"
#import "DeathThroes.h"
#import "Animation.h"
#import "Spaceship.h"
#import "Bullet.h"
#import "BulletView.h"

@implementation EntityCreator
{
    ASHEngine * engine;
}

- (id)initWithEngine:(ASHEngine *)anEngine
{
    self = [super init];
    
    if(self != nil)
    {
        engine = anEngine;
    }
    
    return self;
}

- (void)destroyEntity:(ASHEntity *)entity
{
    [engine removeEntity:entity];
}

- (ASHEntity *)createGame
{
    ASHEntity * gameEntity = [[[ASHEntity alloc] init]
                           addComponent:[[GameState alloc] init]];
    [engine addEntity:gameEntity];
    return gameEntity;
}

- (ASHEntity *)createAsteroidWithRadius:(float)radius
                                   x:(float)x
                                   y:(float)y
{
    ASHEntity * asteroid = [[ASHEntity alloc] init];
    [asteroid addComponent:[[Asteroid alloc] init]];
    Position * position = [[Position alloc] init];
    position.position = CGPointMake(x, y);
    position.rotation = 0;
    [asteroid addComponent:position];
    Collision * collision = [[Collision alloc] init];
    collision.radius = radius;
    [asteroid addComponent:collision];
    Motion * motion = [[Motion alloc] init];
    motion.velocity = CGPointMake(
            ( MathRandom() - 0.5f ) * 4.f * ( 50 - radius),
            ( MathRandom() - 0.5f ) * 4.f * ( 50 - radius));
    motion.angularVelocity = MathRandom() * 2 - 1;
    motion.damping = 0;
    [asteroid addComponent:motion];
    Display * display = [[Display alloc] init];
    display.displayObject = [[AsteroidView alloc] initWithRadius:radius];
    [asteroid addComponent:display];
    [engine addEntity:asteroid];
    return asteroid;
}

- (ASHEntity *)createSpaceship
{
    ASHEntity * spaceship = [[ASHEntity alloc] init];
    ASHEntityStateMachine * fsm = [[ASHEntityStateMachine alloc] initWithEntity:spaceship];
    
    ASHEntityState * playingState = [fsm createState:@"playing"];
   
    Motion * motion = [[Motion alloc] init];
    motion.velocity = CGPointMake(0, 0);
    motion.angularVelocity = 0;
    motion.damping = 15;
    [[playingState add:[Motion class]] withInstance:motion];
    
    MotionControls * motionControls = [[MotionControls alloc] init];
    motionControls.left = TriggerLeft;
    motionControls.right = TriggerRight;
    motionControls.accelerate = TriggerAccelerate;
    motionControls.accelerationRate = 100;
    motionControls.rotationRate = 3;
    [[playingState add:[MotionControls class]] withInstance:motionControls];
    Gun * gun = [[Gun alloc] init];
    gun.offsetFromParent = CGPointMake(8, 0);
    gun.minimumShotInterval = 0.3;
    gun.bulletLifetime = 2;
    [[playingState add:[Gun class]] withInstance:gun];
    GunControls * gunControls = [[GunControls alloc] init];
    gunControls.trigger = TriggerGun;
    [[playingState add:[GunControls class]] withInstance:gunControls];
    Collision * collision = [[Collision alloc] init];
    collision.radius = 9;
    [[playingState add:[Collision class]] withInstance:collision];
    Display * display = [[Display alloc] init];
    display.displayObject = [[SpaceshipView alloc] initSpaceship];
    [[playingState add:[Display class]] withInstance:display];
    
    SpaceshipDeathView * deathView = [[SpaceshipDeathView alloc] initView];
    ASHEntityState * destroyedState = [fsm createState:@"destroyed"];
    DeathThroes * deathThroes = [[DeathThroes alloc] init];
    deathThroes.countdown = 5;
    [[destroyedState add:[DeathThroes class]] withInstance:deathThroes];
    Display * displayDeath = [[Display alloc] init];
    displayDeath.displayObject = deathView;
    [[destroyedState add:[Display class]] withInstance:displayDeath];
    Animation * animation = [[Animation alloc] init];
    animation.animation = deathView;
    [[destroyedState add:[Animation class]] withInstance:animation];
    
    Spaceship * spaceshipComponent = [[Spaceship alloc] init];
    spaceshipComponent.fsm = fsm;
    [spaceship addComponent:spaceshipComponent];
    
    Position * position = [[Position alloc] init];
    position.position = CGPointMake(160, 240);
    position.rotation = 0;
    [spaceship addComponent:position];
    
    [fsm changeState:@"playing"];
    [engine addEntity:spaceship];
    return spaceship;
}

- (ASHEntity *)createUserBullet:(Gun *)gun
              parentPosition:(Position *)parentPosition
{
    float cosVal = cosf(parentPosition.rotation);
    float sinVal = sinf(parentPosition.rotation);
    ASHEntity * bullet = [[ASHEntity alloc] init];
    Bullet * bulletComponent = [[Bullet alloc] init];
    bulletComponent.lifeRemaining = gun.bulletLifetime;
    [bullet addComponent:bulletComponent];
    Position * position = [[Position alloc] init];
    position.position = CGPointMake
    (
        (cosVal * gun.offsetFromParent.x - sinVal * gun.offsetFromParent.y + parentPosition.position.x),
        (sinVal * gun.offsetFromParent.x + cosVal * gun.offsetFromParent.y + parentPosition.position.y)
     );
    position.rotation = 0;
    [bullet addComponent:position];
    Collision * collision = [[Collision alloc] init];
    collision.radius = 0;
    [bullet addComponent:collision];
    Motion * motion = [[Motion alloc] init];
    motion.velocity = CGPointMake(cosVal * 150.f, sinVal * 150.f);
    motion.angularVelocity = 0;
    motion.damping = 0;
    [bullet addComponent:motion];
    Display * display = [[Display alloc] init];
    display.displayObject = [[BulletView alloc] initBullet];
    [bullet addComponent:display];
    [engine addEntity:bullet];
    return bullet;
}

@end
