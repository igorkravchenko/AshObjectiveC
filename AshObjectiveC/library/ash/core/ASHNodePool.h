
#import <Foundation/Foundation.h>
#import "ASHNode.h"

@interface ASHNodePool : NSObject

- (instancetype __nonnull)initWithNodeClass:(Class __nonnull)nodeClass
             components:(NSMapTable * __nonnull)components;
- (ASHNode * __nullable)getNode;
- (void)disposeNode:(ASHNode * __nonnull)node;
- (void)cacheNode:(ASHNode * __nonnull)node;
- (void)releaseCache;

@end
