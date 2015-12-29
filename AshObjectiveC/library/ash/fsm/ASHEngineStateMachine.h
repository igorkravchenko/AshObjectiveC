
#import <Foundation/Foundation.h>

@class ASHEngine;
@class ASHEngineState;


@interface ASHEngineStateMachine : NSObject

@property (nonatomic, weak) ASHEngine * engine;

- (instancetype)initWithEngine:(ASHEngine *)engine;
- (ASHEngineStateMachine *)addState:(NSString *)name
                              state:(ASHEngineState *)state;
- (ASHEngineState *)createState:(NSString *)name;
- (void)changeState:(NSString *)name;

@end