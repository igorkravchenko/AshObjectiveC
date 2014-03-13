
#import <Foundation/Foundation.h>
#import "ASHEntity.h"
#import "ASHEntityState.h"

@interface ASHEntityStateMachine : NSObject

- (id)initWithEntity:(ASHEntity *)entity;
- (ASHEntityStateMachine *)addState:(NSString *)name
                           state:(ASHEntityState *)state;
- (ASHEntityState *)createState:(NSString *)name;
- (void)changeState:(NSString *)name;

@end
