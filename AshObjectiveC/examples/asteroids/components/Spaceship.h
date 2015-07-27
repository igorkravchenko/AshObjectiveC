
#import <Foundation/Foundation.h>
#import "ASHEntityStateMachine.h"

@interface Spaceship : NSObject

@property (nonatomic, strong) ASHEntityStateMachine * fsm;

- (instancetype)initWithFsm:(ASHEntityStateMachine *)fsm;


@end
