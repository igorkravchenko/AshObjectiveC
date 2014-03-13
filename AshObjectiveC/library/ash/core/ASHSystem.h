
#import <Foundation/Foundation.h>
#import "ASHEngine.h"

@interface ASHSystem : NSObject

@property (nonatomic, weak) ASHSystem * previous;

@property (nonatomic, strong) ASHSystem * next;

@property (nonatomic, assign) NSInteger priority;

- (void)addToEngine:(ASHEngine *)engine;

- (void)removeFromEngine:(ASHEngine *)engine;

- (void)update:(double)time;

@end
