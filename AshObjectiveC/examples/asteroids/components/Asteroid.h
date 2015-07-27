
#import <Foundation/Foundation.h>

@class ASHEntityStateMachine;

@interface Asteroid : NSObject

@property (nonatomic, strong) ASHEntityStateMachine * fsm;

- (instancetype)initWithFsm:(ASHEntityStateMachine *)fsm;


@end
