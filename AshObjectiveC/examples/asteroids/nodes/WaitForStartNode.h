
#import <Foundation/Foundation.h>
#import "ASHNode.h"

@class WaitForStart;

@interface WaitForStartNode : ASHNode

@property (nonatomic, weak) WaitForStart * wait;

@end