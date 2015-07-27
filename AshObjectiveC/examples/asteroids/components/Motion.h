
#import <Foundation/Foundation.h>

@interface Motion : NSObject

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) float angularVelocity;
@property (nonatomic, assign) float damping;

- (instancetype)initWithVelocityX:(float)velocityX
                        velocityY:(float)velocityY
                  angularVelocity:(float)angularVelocity
                          damping:(float)damping;


@end
