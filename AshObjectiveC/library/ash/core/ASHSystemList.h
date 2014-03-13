
#import <Foundation/Foundation.h>
#import "ASHSystem.h"

@interface ASHSystemList : NSObject

@property (nonatomic, strong) ASHSystem * head;
@property (nonatomic, strong) ASHSystem * tail;

- (void)addSystem:(ASHSystem *)system;
- (void)removeSystem:(ASHSystem *)system;
- (void)removeAll;
- (ASHSystem *)getSystem:(Class)type;

@end
