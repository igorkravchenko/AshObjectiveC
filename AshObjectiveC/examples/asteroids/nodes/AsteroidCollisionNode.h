
#import "ASHNode.h"
#import "Asteroid.h"
#import "Position.h"
#import "Collision.h"

@interface AsteroidCollisionNode : ASHNode

@property (nonatomic, strong) Asteroid * asteroid;
@property (nonatomic, strong) Position * position;
@property (nonatomic, strong) Collision * collision;

@end
