
#import "ASHNodePool.h"

@interface ASHNodePool ()

@property (nonatomic, strong) ASHNode * tail;
@property (nonatomic, assign) Class nodeClass;
@property (nonatomic, strong) ASHNode * cacheTail;

@end

@implementation ASHNodePool

@synthesize tail;
@synthesize nodeClass;
@synthesize cacheTail;

- (id)initWithNodeClass:(Class)aNodeClass
{
    self = [super init];
    
    if(self != nil)
    {
        self.nodeClass = aNodeClass;
    }
    
    return self;
}

- (ASHNode *)getNode
{
    if(tail != nil)
    {
        ASHNode * node = tail;
        self.tail = tail.previous;
        node.previous = nil;
        return node;
    }
    else
    {
        return [[nodeClass alloc] init];
    }
}

- (void)disposeNode:(ASHNode *)node
{
    node.next = nil;
    node.previous = tail;
    self.tail = node;
}

- (void)cacheNode:(ASHNode *)node
{
    node.previous = cacheTail;
    self.cacheTail = node;
}

- (void)releaseCache
{
    while (cacheTail != nil) 
    {
        ASHNode * node = cacheTail;
        self.cacheTail = node.previous;
        node.next = nil;
        node.previous = tail;
        self.tail = node;
    }
}

@end
