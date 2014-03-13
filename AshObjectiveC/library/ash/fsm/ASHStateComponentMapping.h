
#import <Foundation/Foundation.h>
#import "ASHComponentProvider.h"

@class ASHEntityState;

@interface ASHStateComponentMapping : NSObject

- (id)initWithCreatingState:(ASHEntityState *)creatingState
                       type:(Class)type;

- (ASHStateComponentMapping *)withInstance:(id)component;
- (ASHStateComponentMapping *)withType:(Class)type;
- (ASHStateComponentMapping *)withSingleton;
- (ASHStateComponentMapping *)withSingletonForType:(Class)type;
- (ASHStateComponentMapping *)withTarget:(id)target
                                  method:(SEL)method;
- (ASHStateComponentMapping *)withProvider:(id <ASHComponentProvider>)provider;
- (ASHStateComponentMapping *)add:(Class)type;

@end
