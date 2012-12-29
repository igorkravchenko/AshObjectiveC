
#import <Foundation/Foundation.h>
#import "ASHEngine.h"
#import "ASHEntity.h"
#import "Gun.h"
#import "Position.h"

@interface EntityCreator : NSObject

- (id)initWithEngine:(ASHEngine *)engine;
- (void)destroyEntity:(ASHEntity *)entity;
- (ASHEntity *)createGame;
- (ASHEntity *)createAsteroidWithRadius:(float)radius
                                   x:(float)x
                                   y:(float)y;
- (ASHEntity *)createSpaceship;
- (ASHEntity *)createUserBullet:(Gun *)gun
              parentPosition:(Position *)parentPosition;
@end
