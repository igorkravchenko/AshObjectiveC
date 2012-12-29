
#import "ASHNode.h"
#import "Spaceship.h"
#import "Position.h"

@interface SpaceshipNode : ASHNode

@property (nonatomic, strong) Spaceship * spaceship;
@property (nonatomic, strong) Position * position;

@end
