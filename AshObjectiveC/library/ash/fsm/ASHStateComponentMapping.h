
#import <Foundation/Foundation.h>
#import "ASHComponentProvider.h"

@class ASHEntityState;

@interface ASHStateComponentMapping : NSObject

- (instancetype __nonnull)initWithCreatingState:(ASHEntityState * __nonnull)creatingState
                       type:(Class __nonnull)type;

- (ASHStateComponentMapping * __nonnull)withInstance:(id __nonnull)component;
- (ASHStateComponentMapping * __nonnull)withType:(Class __nonnull)type;
- (ASHStateComponentMapping * __nonnull)withSingleton;
- (ASHStateComponentMapping * __nonnull)withSingletonForType:(Class __nonnull)type;
- (ASHStateComponentMapping * __nonnull)withTarget:(id __nonnull)target
                                  method:(SEL __nonnull)method;
- (ASHStateComponentMapping * __nonnull)withProvider:(id <ASHComponentProvider> __nonnull)provider;
- (ASHStateComponentMapping * __nonnull)add:(Class __nonnull)type;

@end
