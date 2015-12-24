
#import <Foundation/Foundation.h>
#import "ASHEntity.h"

@interface ASHNode : NSObject
{
    @public
    __weak ASHEntity * entity;
    __weak ASHNode * previous;
    __strong ASHNode * next;
}

@property (nonatomic, readonly, nonnull) ASHEntity * entity;

@property (nonatomic, weak, nullable) ASHNode * previous;

@property (nonatomic, strong, nullable) ASHNode * next;

@end
