
#import "ASHNode.h"
#import "Position.h"
#import "Display.h"

@interface RenderNode : ASHNode

@property (nonatomic, weak) Position * position;
@property (nonatomic, weak) Display * display;

@end
