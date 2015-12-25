
#import <Foundation/Foundation.h>
#import "ASHSignal1.h"
#import "ASHNode.h"

@interface ASHNodeList : NSObject <NSFastEnumeration>
{
@public
    __strong ASHNode * __nullable head;
    __strong ASHNode * __nullable tail;
@package
    __strong ASHSignal1 * __nonnull nodeAdded;
    __strong ASHSignal1 * __nonnull nodeRemoved;
}

@property (nullable, nonatomic, strong) ASHNode * head;

@property (nullable, nonatomic, strong) ASHNode * tail;

@property (nonnull, nonatomic, readonly) ASHSignal1 * nodeAdded;

@property (nonnull, nonatomic, readonly) ASHSignal1 * nodeRemoved;

- (void)addNode:(nonnull ASHNode *)node;
- (void)removeNode:(nonnull ASHNode *)node;
- (void)removeAll;

- (BOOL)isEmpty;

- (void)swapNode:(nonnull ASHNode *)node1
            node:(nonnull ASHNode *)node2;

- (void)insertionSortUsingBlock:(float (^__nonnull)(ASHNode * __nonnull, ASHNode * __nonnull))sortBlock;
- (void)mergeSortUsingBlock:(float (^__nonnull)(ASHNode * __nonnull, ASHNode * __nonnull))sortBlock;

@end
