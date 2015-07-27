
#import "ASHNode.h"
#import "Position.h"
#import "Motion.h"

@interface MovementNode : ASHNode

@property (nonatomic, weak) Position * position;
@property (nonatomic, weak) Motion * motion;

@end
