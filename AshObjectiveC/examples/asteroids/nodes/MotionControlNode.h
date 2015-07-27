
#import "ASHNode.h"
#import "MotionControls.h"
#import "Position.h"
#import "Motion.h"

@interface MotionControlNode : ASHNode

@property (nonatomic, weak) MotionControls * control;
@property (nonatomic, weak) Position * position;
@property (nonatomic, weak) Motion * motion;

@end
