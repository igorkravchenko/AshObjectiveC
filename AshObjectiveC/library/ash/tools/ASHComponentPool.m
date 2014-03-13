
#import "ASHComponentPool.h"

@interface ASHComponentPool ()

@property (nonatomic, strong) NSCache * pools;

@end


@implementation ASHComponentPool

@synthesize pools;

+ (instancetype)sharedPool
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
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
