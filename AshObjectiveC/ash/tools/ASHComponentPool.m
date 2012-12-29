
#import "ASHComponentPool.h"

@interface ASHComponentPool ()

@property (nonatomic, retain) NSCache * pools;

@end

static id __sharedInstance = nil;

@implementation ASHComponentPool

@synthesize pools;

+ (id)sharedInstance
{
    if(__sharedInstance == nil)
    {
        __sharedInstance = [[self alloc] init];
    }
    
    return __sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if(self != nil)
    {
        self.pools = [[NSCache alloc] init];
    }
    
    return self;
}

- (NSMutableSet *)getPool:(Class)componentClass
{
    NSString * componentClassKey = NSStringFromClass(componentClass);
    NSMutableSet * pool = [pools objectForKey:componentClassKey];
    if(pool == nil)
    {
        pool = [NSMutableSet set];
        [pools setObject:pool forKey:componentClassKey];
    }
    
    return pool;
}

- (id)getComponent:(Class)componentClass
{
    NSMutableSet * pool = [self getPool:componentClass];
    id component = nil;
    if(pool.count > 0)
    {
        component = [pool anyObject];
        [pool removeObject:component];
    }
    else
    {
        component = [[componentClass alloc] init];
    }
    
    return component;
}

- (void)disposeComponent:(id)component
{
    if(component != nil)
    {
        NSMutableSet * pool = [self getPool:[component class]];
        [pool addObject:component];
    }
}

- (void)empty
{
    self.pools = [[NSCache alloc] init];
}

@end
