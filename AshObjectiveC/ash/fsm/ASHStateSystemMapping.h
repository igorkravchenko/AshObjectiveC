
#import <Foundation/Foundation.h>

@class ASHEngineState;
@class ASHSystem;
@protocol ASHSystemProvider;

@interface ASHStateSystemMapping : NSObject

- (instancetype)initWithCreatingState:(ASHEngineState *)creatingState
                             provider:(id <ASHSystemProvider>)provider;
- (instancetype)withPriority:(NSInteger)priority;
- (instancetype)addInstance:(ASHSystem *)system1;
- (instancetype)addSingleton:(Class)type;
- (instancetype)addMethod:(id)target
                   action:(SEL)action;
- (instancetype)addProvider:(id <ASHSystemProvider>)provider;

@end