
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

- (void)addToEngine:(ASHEngine *)engine;

- (void)removeFromEngine:(ASHEngine *)engine;

- (void)update:(double)time;

@end
