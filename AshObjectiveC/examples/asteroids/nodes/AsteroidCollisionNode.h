
#import "ASHNode.h"
#import "Asteroid.h"
#import "Position.h"
#import "Collision.h"

@class Audio;

@interface AsteroidCollisionNode : ASHNode

@property (nonatomic, weak) Asteroid * asteroid;
@property (nonatomic, weak) Position * position;
@property (nonatomic, weak) Collision * collision;
@property (nonatomic, weak) Audio * audio;

@end
