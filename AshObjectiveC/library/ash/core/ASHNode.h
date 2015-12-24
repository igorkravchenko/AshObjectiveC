
#import <Foundation/Foundation.h>
#import "ASHEntity.h"

@interface ASHNode : NSObject
{
    @public
    __weak ASHEntity * _Nonnull entity;
    __weak ASHNode  * _Nullable previous;
    __strong ASHNode  * _Nullable next;
}

@property (nonatomic, readonly, nonnull) ASHEntity * entity;

@property (nonatomic, weak, nullable) ASHNode * previous;

@property (nonatomic, strong, nullable) ASHNode  * next;

@end
