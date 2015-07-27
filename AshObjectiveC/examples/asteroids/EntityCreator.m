
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
#import "GameConfig.h"
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
#import "WaitForStartView.h"
#import "WaitForStart.h"
#import "AsteroidDeathView.h"
#import "Audio.h"
#import "Hud.h"
#import "HudView.h"

@implementation EntityCreator
{
    ASHEngine * engine;
    ASHEntity * waitEntity;
    GameConfig * gameConfig;
}

- (id)initWithEngine:(ASHEngine *)anEngine
          gameConfig:(GameConfig *)aGameConfig
{
    self = [super init];
    
    if(self != nil)
    {
        engine = anEngine;
        gameConfig = aGameConfig;
    }
    
    return self;
}

- (void)destroyEntity:(ASHEntity *)entity
{
    [engine removeEntity:entity];
}

- (ASHEntity *)createGame
{
    HudView * hud = [[HudView alloc] initWithSize:CGSizeMake(gameConfig.width, gameConfig.height)];
    ASHEntity * gameEntity = [[[ASHEntity alloc] initWithName:@"game"]
                           addComponent:[[GameState alloc] init]];
    [gameEntity addComponent:[[Hud alloc] initWithView:hud]];
    [gameEntity addComponent:[[Display alloc] initWithDisplayObject:hud]];
    [gameEntity addComponent:[[Position alloc] initWithX:0 y:0 rotation:0]];
    [engine addEntity:gameEntity];
    return gameEntity;
}

- (ASHEntity *)createWaitForClick
{
    if(!waitEntity)
    {
        CGRect screenRect = CGRectMake(0, 0, gameConfig.width, gameConfig.height);
        WaitForStartView * waitView = [[WaitForStartView alloc] initWithSize:CGSizeMake(gameConfig.width, gameConfig.height)];

        waitEntity = [[ASHEntity alloc] initWithName:@"wait"];
        [waitEntity addComponent:[[WaitForStart alloc] initWithWaitForStart:waitView]];
        [waitEntity addComponent:[[Display alloc] initWithDisplayObject:waitView]];
        [waitEntity addComponent:[[Position alloc] initWithX:CGRectGetMidX(screenRect)
                                                           y:CGRectGetMidY(screenRect)
                                                    rotation:0]];
    }
    ((WaitForStart *) [waitEntity getComponent:WaitForStart.class]).startGame = NO;
    [engine addEntity:waitEntity];
    return waitEntity;
}

- (ASHEntity *)createAsteroidWithRadius:(float)radius
                                   x:(float)x
                                   y:(float)y
{
    ASHEntity * asteroid = [[ASHEntity alloc] init];

    ASHEntityStateMachine * fsm = [[ASHEntityStateMachine alloc] initWithEntity:asteroid];

    ASHEntityState * aliveState = [fsm createState:@"alive"];
    Motion * motion = [[Motion alloc] initWithVelocityX:( MathRandom() - 0.5f ) * 4.f * ( 50 - radius)
                                              velocityY:( MathRandom() - 0.5f ) * 4.f * ( 50 - radius)
                                        angularVelocity:MathRandom() * 2.f - 1.f
                                                damping:0];
    [[aliveState add:motion.class] withInstance:motion];
    Collision * collision = [[Collision alloc] initWithRadius:radius];
    [[aliveState add:collision.class] withInstance:collision];
    Display * display = [[Display alloc] initWithDisplayObject:[[AsteroidView alloc] initWithRadius:radius]];
    [[aliveState add:display.class] withInstance:display];

    AsteroidDeathView * asteroidDeathView = [[AsteroidDeathView alloc] initWithRadius:radius];
    ASHEntityState  * destroyedState = [fsm createState:@"destroyed"];
    DeathThroes * deathThroes = [[DeathThroes alloc] initWithCountdown:3];
    [[destroyedState add:deathThroes.class] withInstance:deathThroes];
    Display * displayDeathView = [[Display alloc] initWithDisplayObject:asteroidDeathView];
    [[destroyedState add:display.class] withInstance:displayDeathView];
    Animation * animation = [[Animation alloc] initWithAnimation:asteroidDeathView];
    [[destroyedState add:animation.class] withInstance:animation];

    [asteroid addComponent:[[Asteroid alloc] initWithFsm:fsm]];
    [asteroid addComponent:[[Position alloc] initWithX:x y:y rotation:0]];
    [asteroid addComponent:[[Audio alloc] init]];

    [fsm changeState:@"alive"];

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
    display.displayObject = [[SpaceshipView alloc] init];
    [[playingState add:[Display class]] withInstance:display];

    SpaceshipDeathView * deathView = [[SpaceshipDeathView alloc] init];
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
    CGRect screenRect = CGRectMake(0, 0, gameConfig.width, gameConfig.height);
    position.position = CGPointMake(CGRectGetMidX(screenRect), CGRectGetMidY(screenRect));
    position.rotation = 0;
    [spaceship addComponent:position];

    Audio * audio = [[Audio alloc] init];
    [spaceship addComponent:audio];

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
    display.displayObject = [[BulletView alloc] init];
    [bullet addComponent:display];
    [engine addEntity:bullet];
    return bullet;
}
@end
