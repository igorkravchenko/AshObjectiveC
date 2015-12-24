
#import <Foundation/Foundation.h>
#import "ASHEntity.h"

@interface ASHNode : NSObject
{
    @public
    __weak ASHEntity * __nonnull entity;
    __weak ASHNode  * __nullable previous;
    __strong ASHNode  * __nullable next;
}

@property (nonnull, nonatomic, readonly) ASHEntity * entity;

@property (nullable, nonatomic, weak) ASHNode * previous;

@property (nullable, nonatomic, strong) ASHNode  * next;

@end
