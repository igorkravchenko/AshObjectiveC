
#import "ASHNode.h"
#import "Collision.h"
#import "Position.h"
#import "Spaceship.h"

@interface SpaceshipCollisionNode : ASHNode

@property (nonatomic, strong) Spaceship * spaceship;
@property (nonatomic, strong) Position * position;
@property (nonatomic, strong) Collision * collision;

@end
