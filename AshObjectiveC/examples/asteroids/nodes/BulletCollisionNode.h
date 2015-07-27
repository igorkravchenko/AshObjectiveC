
#import "ASHNode.h"
#import "Bullet.h"
#import "Collision.h"
#import "Position.h"

@interface BulletCollisionNode : ASHNode

@property (nonatomic, weak) Bullet * bullet;
@property (nonatomic, weak) Position * position;
@property (nonatomic, weak) Collision * collision;

@end
