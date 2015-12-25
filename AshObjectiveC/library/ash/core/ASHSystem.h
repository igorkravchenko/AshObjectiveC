
#import <Foundation/Foundation.h>
#import "ASHEngine.h"

@interface ASHSystem : NSObject
{
    @package
    __weak ASHSystem * previous;
    __strong ASHSystem * next;
    NSInteger priority;
}


@property (nonatomic, assign) NSInteger priority;

- (void)addToEngine:(nonnull ASHEngine *)engine;

- (void)removeFromEngine:(nonnull ASHEngine *)engine;

- (void)update:(double)time;

@end
