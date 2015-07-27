
#import <Foundation/Foundation.h>
#import "ASHEngine.h"
#import "ASHEntity.h"
#import "Gun.h"
#import "Position.h"

@class GameConfig;

@interface EntityCreator : NSObject

- (id)initWithEngine:(ASHEngine *)engine
          gameConfig:(GameConfig *)gameConfig;
- (void)destroyEntity:(ASHEntity *)entity;
- (ASHEntity *)createGame;
- (ASHEntity *)createWaitForClick;
- (ASHEntity *)createAsteroidWithRadius:(float)radius
                                      x:(float)x
                                      y:(float)y;
- (ASHEntity *)createSpaceship;

- (ASHEntity *)createUserBullet:(Gun *)gun
              parentPosition:(Position *)parentPosition;

@end
