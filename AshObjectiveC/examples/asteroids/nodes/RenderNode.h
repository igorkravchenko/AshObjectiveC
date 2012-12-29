
#import "ASHNode.h"
#import "Position.h"
#import "Display.h"

@interface RenderNode : ASHNode

@property (nonatomic, strong) Position * position;
@property (nonatomic, strong) Display * display;

@end
