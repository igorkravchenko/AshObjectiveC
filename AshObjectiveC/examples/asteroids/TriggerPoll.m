
#import "TriggerPoll.h"

@implementation TriggerPoll
{
    NSMutableArray * triggers;
}

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        triggers = @[].mutableCopy;
    }
    
    return self;
}

- (void)addTrigger:(Trigger)trigger
{
    if(![triggers containsObject:@(trigger)])
    {
        [triggers addObject:@(trigger)];
    }
}

- (void)removeTrigger:(Trigger)trigger
{
    if([triggers containsObject:@(trigger)])
    {
        [triggers removeObject:@(trigger)];
    }
}

- (BOOL)isActive:(Trigger)trigger
{
    return [triggers containsObject:@(trigger)];
}

@end
