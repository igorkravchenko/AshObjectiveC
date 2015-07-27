
#import "ASHNode.h"

@class GameState;
@class Hud;

@interface HudNode : ASHNode

@property (nonatomic, weak) GameState * state;
@property (nonatomic, weak) Hud * hud;

@end