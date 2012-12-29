
#import <Foundation/Foundation.h>
#import "TriggerPoll.h"

@interface Asteroids : NSObject

@property (nonatomic, readonly) TriggerPoll * triggerPoll;

- (id)initWithContainer:(UIView *)container
                  width:(float)width
                 height:(float)height;
- (void)start;

@end
