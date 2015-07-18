
#import <Foundation/Foundation.h>
#import "ASHEntity.h"

@interface ASHNode : NSObject
{
    @public
    __weak ASHEntity * entity;
    __weak ASHNode * previous;
    __strong ASHNode * next;
}

@property (nonatomic, weak) ASHEntity * entity;

@property (nonatomic, weak) ASHNode * previous;

@property (nonatomic, strong) ASHNode * next;

@end
