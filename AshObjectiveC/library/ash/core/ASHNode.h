
#import <Foundation/Foundation.h>
#import "ASHEntity.h"

@interface ASHNode : NSObject

@property (nonatomic, strong) ASHEntity * entity;

@property (nonatomic, weak) ASHNode * previous;

@property (nonatomic, strong) ASHNode * next;

@end
