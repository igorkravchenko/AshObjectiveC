
#import "ASHNode.h"
#import "Bullet.h"
#import "Collision.h"
#import "Position.h"

@interface BulletCollisionNode : ASHNode

@property (nonatomic, strong) Bullet * bullet;
@property (nonatomic, strong) Position * position;
@property (nonatomic, strong) Collision * collision;

@end
