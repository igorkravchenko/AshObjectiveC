
#import "ASHNode.h"
#import "Position.h"
#import "Motion.h"

@interface MovementNode : ASHNode

@property (nonatomic, strong) Position * position;
@property (nonatomic, strong) Motion * motion;

@end
