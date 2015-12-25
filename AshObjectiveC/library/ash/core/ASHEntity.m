
#import "ASHEntity.h"
#import <objc/runtime.h>

static NSInteger nameCount = 0;

@implementation ASHEntity
{
    NSString * _name;
}

@synthesize componentAdded;
@synthesize componentRemoved;

@synthesize components;
@synthesize nameChanged;

- (instancetype)init
{
    self = [super init];
    
    if(self != nil)
    {
        componentAdded = [[ASHSignal2 alloc] init] ;
        componentRemoved = [[ASHSignal2 alloc] init];
        components = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsObjectPersonality
                                           valueOptions:NSPointerFunctionsStrongMemory];
        nameChanged = [[ASHSignal2 alloc] init];
        _name = [@"_entity" stringByAppendingFormat:@"%ld", (long)++nameCount];
    }
    
    return self;
}

- (instancetype __nonnull)initWithName:(NSString * __nullable)name
{
    self = [super init];

    if(self != nil)
    {
        componentAdded = [[ASHSignal2 alloc] init] ;
        componentRemoved = [[ASHSignal2 alloc] init];
        components = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsObjectPersonality
                                           valueOptions:NSPointerFunctionsStrongMemory];
        nameChanged = [[ASHSignal2 alloc] init];
        _name = name != nil ? name : [@"_entity" stringByAppendingFormat:@"%ld", (long)++nameCount];
    }

    return self;
}

- (ASHEntity * __nonnull)addComponent:(id __nonnull)component
                       componentClass:(Class __nonnull)componentClass
{
    if(componentClass == nil)
    {
        componentClass = [component class];
    }

    if([components objectForKey:componentClass] != nil)
    {
        [self removeComponent:componentClass];
    }

    [components setObject:component
                   forKey:componentClass];
    
    [componentAdded dispatchWithObject:self
                            withObject:componentClass];
    return self;
}

- (ASHEntity * __nonnull)addComponent:(id __nonnull)component
{
    Class componentClass = [component class];

    if([components objectForKey:componentClass] != nil)
    {
        [self removeComponent:componentClass];
    }
    
    [components setObject:component
                   forKey:componentClass];
    
    [componentAdded dispatchWithObject:self
                            withObject:componentClass];
    return self;
}

- (id __nullable)removeComponent:(Class __nonnull)componentClass
{
    id component = [components objectForKey:componentClass];

    if(component != nil)
    {
        [components removeObjectForKey:componentClass];
        [componentRemoved dispatchWithObject:self 
                                  withObject:componentClass];
        return component;
    }
    
    return nil;
}

- (id __nullable)getComponent:(Class __nonnull)componentClass
{
    return [components objectForKey:componentClass];
}

- (NSArray * __nonnull)allComponents
{
    NSMutableArray * allComponents = NSMutableArray.array;

    for (Class key in components)
    {
        [allComponents addObject:[components objectForKey:key]];
    }

    return allComponents;
}

- (BOOL)hasComponent:(Class __nonnull)componentClass
{    
    return [components objectForKey:componentClass] != nil;
}

- (NSString * __nonnull)name
{
    return _name;
}

- (void)setName:(NSString * __nonnull)value
{
    if(_name != value)
    {
        NSString * previousName = _name;
        _name = value;
        [nameChanged dispatchWithObject:self
                             withObject:previousName];
    }
}

@end
