
#import "ASHNode.h"
#import "GunControls.h"
#import "Gun.h"
#import "Position.h"

@interface GunControlNode : ASHNode

@property (nonatomic, strong) GunControls * control;
@property (nonatomic, strong) Gun * gun;
@property (nonatomic, strong) Position * position;

@end
