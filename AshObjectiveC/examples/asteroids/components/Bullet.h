
#import <Foundation/Foundation.h>

@interface Bullet : NSObject

@property (nonatomic, assign) float lifeRemaining;

- (instancetype)initWithLifeRemaining:(float)lifetime;

@end
