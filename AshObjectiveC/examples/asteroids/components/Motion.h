
#import <Foundation/Foundation.h>

@interface Motion : NSObject

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) float angularVelocity;
@property (nonatomic, assign) float damping;

@end
