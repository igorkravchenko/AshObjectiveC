
#import "ASHNode.h"
#import "GunControls.h"
#import "Gun.h"
#import "Position.h"

@class Audio;

@interface GunControlNode : ASHNode

@property (nonatomic, weak) GunControls * control;
@property (nonatomic, weak) Gun * gun;
@property (nonatomic, weak) Position * position;
@property (nonatomic, weak) Audio * audio;

@end
