
#import <Foundation/Foundation.h>
#import "ASHListenerNode.h"

@interface ASHListenerNodePool : NSObject

- (ASHListenerNode *)get;
- (void)dispose:(ASHListenerNode *)node;
- (void)cache:(ASHListenerNode *)node;
- (void)releaseCache;

@end
