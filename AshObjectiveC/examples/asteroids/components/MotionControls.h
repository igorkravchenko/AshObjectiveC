
#import <Foundation/Foundation.h>

@interface MotionControls : NSObject

@property (nonatomic, assign) NSUInteger left;
@property (nonatomic, assign) NSUInteger right;
@property (nonatomic, assign) NSUInteger accelerate;

@property (nonatomic, assign) float accelerationRate;
@property (nonatomic, assign) float rotationRate;

- (instancetype)initWithLeft:(NSUInteger)left
                       right:(NSUInteger)right
                  accelerate:(NSUInteger)accelerate
            accelerationRate:(float)accelerationRate
                rotationRate:(float)rotationRate;

@end
