
#import "ASHNode.h"
#import "Collision.h"
#import "Position.h"
#import "Spaceship.h"

@class Audio;

@interface SpaceshipCollisionNode : ASHNode

@property (nonatomic, weak) Spaceship * spaceship;
@property (nonatomic, weak) Position * position;
@property (nonatomic, weak) Collision * collision;
@property (nonatomic, weak) Audio * audio;

@end
