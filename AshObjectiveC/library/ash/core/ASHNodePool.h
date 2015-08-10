
#import <Foundation/Foundation.h>
#import "ASHNode.h"

@interface ASHNodePool : NSObject

- (id)initWithNodeClass:(Class)nodeClass
             components:(NSMapTable *)components;
- (ASHNode *)getNode;
- (void)disposeNode:(ASHNode *)node;
- (void)cacheNode:(ASHNode *)node;
- (void)releaseCache;

@end
