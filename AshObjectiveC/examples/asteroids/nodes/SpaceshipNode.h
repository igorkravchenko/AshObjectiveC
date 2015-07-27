
#import "ASHNode.h"
#import "Spaceship.h"
#import "Position.h"

@interface SpaceshipNode : ASHNode

@property (nonatomic, weak) Spaceship * spaceship;
@property (nonatomic, weak) Position * position;

@end
