
#import "ASHNode.h"
#import "MotionControls.h"
#import "Position.h"
#import "Motion.h"

@interface MotionControlNode : ASHNode

@property (nonatomic, strong) MotionControls * control;
@property (nonatomic, strong) Position * position;
@property (nonatomic, strong) Motion * motion;

@end
