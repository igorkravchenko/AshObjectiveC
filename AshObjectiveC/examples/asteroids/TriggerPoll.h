
#import <Foundation/Foundation.h>
#import "Trigger.h"

@interface TriggerPoll : NSObject

- (void)addTrigger:(Trigger)trigger;
- (void)removeTrigger:(Trigger)trigger;
- (BOOL)isActive:(Trigger)trigger;

@end
