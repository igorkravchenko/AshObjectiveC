
#import "ASHListIteratingSystem.h"
#import "TriggerPoll.h"
#import "EntityCreator.h"

@interface GunControlSystem : ASHListIteratingSystem

- (id)initWithTriggerPoll:(TriggerPoll *)triggerPoll
                  creator:(EntityCreator *)creator;

@end
