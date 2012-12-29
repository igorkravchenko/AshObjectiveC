
#import "ASHSystem.h"
#import "EntityCreator.h"
#import "GameConfig.h"

@interface GameManager : ASHSystem

- (id)initWithCreator:(EntityCreator *)aCreator
               config:(GameConfig *)aConfig;
@end
