
#import <Foundation/Foundation.h>
#import "ASHEntity.h"
#import "ASHEntityState.h"

@interface ASHEntityStateMachine : NSObject

- (instancetype __nonnull)initWithEntity:(ASHEntity * __nonnull)entity;
- (ASHEntityStateMachine * __nonnull)addState:(NSString * __nonnull)name
                           state:(ASHEntityState * __nonnull)state;
- (ASHEntityState * __nonnull)createState:(NSString * __nonnull)name;
- (void)changeState:(NSString * __nonnull)name;

@end
