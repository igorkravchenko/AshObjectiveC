
#import <Foundation/Foundation.h>

@interface Gun : NSObject

@property (nonatomic, assign) BOOL shooting;
@property (nonatomic, assign) CGPoint offsetFromParent;
@property (nonatomic, assign) float timeSinceLastShot;
@property (nonatomic, assign) float minimumShotInterval;
@property (nonatomic, assign) float bulletLifetime;



@end
