
#import <Foundation/Foundation.h>
#import "ASHEntity.h"

@interface ASHNode : NSObject
{
    @public
    __weak ASHEntity * _Nonnull entity;
    __weak ASHNode  * _Nullable previous;
    __strong ASHNode  * _Nullable next;
}

@property (nonnull, nonatomic, readonly) ASHEntity * entity;

@property (nullable, nonatomic, weak) ASHNode * previous;

@property (nullable, nonatomic, strong) ASHNode  * next;

@end
