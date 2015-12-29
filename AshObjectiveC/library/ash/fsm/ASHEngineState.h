
#import <Foundation/Foundation.h>

@class ASHStateSystemMapping;
@class ASHSystem;
@protocol ASHSystemProvider;

@interface ASHEngineState : NSObject

@property (nonnull, nonatomic, readonly) NSMutableArray * providers;

- (ASHStateSystemMapping * __nonnull)addInstance:(ASHSystem * __nonnull)system;
- (ASHStateSystemMapping * __nonnull)addSingleton:(Class __nonnull)aClass;
- (ASHStateSystemMapping * __nonnull)addMethod:(id __nonnull)target
                              action:(SEL __nonnull)action;
- (ASHStateSystemMapping * __nonnull)addProvider:(id <ASHSystemProvider> __nonnull)provider;

@end