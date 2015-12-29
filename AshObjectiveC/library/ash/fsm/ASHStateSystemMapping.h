
#import <Foundation/Foundation.h>

@class ASHEngineState;
@class ASHSystem;
@protocol ASHSystemProvider;

@interface ASHStateSystemMapping : NSObject

- (instancetype __nonnull)initWithCreatingState:(ASHEngineState * __nonnull)creatingState
                             provider:(id <ASHSystemProvider> __nonnull)provider;
- (instancetype __nonnull)withPriority:(NSInteger)priority;
- (instancetype __nonnull)addInstance:(ASHSystem * __nonnull)system1;
- (instancetype __nonnull)addSingleton:(Class __nonnull)type;
- (instancetype __nonnull)addMethod:(id __nonnull)target
                   action:(SEL __nonnull)action;
- (instancetype __nonnull)addProvider:(id <ASHSystemProvider> __nonnull)provider;

@end