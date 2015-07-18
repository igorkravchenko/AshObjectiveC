
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

- (id)init
{
    self = [super init];
    
    if(self != nil)
    {
        componentAdded = [[ASHSignal2 alloc] init] ;
        componentRemoved = [[ASHSignal2 alloc] init];
        components = [NSMutableDictionary dictionary];
        nameChanged = [[ASHSignal2 alloc] init];
        _name = [@"_entity" stringByAppendingFormat:@"%ld", (long)++nameCount];
    }
    
    return self;
}

- (id)initWithName:(NSString *)name
{
    self = [super init];

    if(self != nil)
    {
        componentAdded = [[ASHSignal2 alloc] init] ;
        componentRemoved = [[ASHSignal2 alloc] init];
        components = [NSMutableDictionary dictionary];
        nameChanged = [[ASHSignal2 alloc] init];
        _name = name != nil ? name : [@"_entity" stringByAppendingFormat:@"%ld", (long)++nameCount];
    }

    return self;
}

- (ASHEntity *)addComponent:(id)component
          componentClass:(Class)componentClass
{
    if(componentClass == nil)
    {
        componentClass = [component class];
    }
    
    NSString * componentClassKey = NSStringFromClass(componentClass);
    
    if(components[componentClassKey] != nil)
    {
        [self removeComponent:componentClass];
    }
    
    components[componentClassKey] = component;
    
    [componentAdded dispatchWithObject:self
                            withObject:componentClass];
    return self;
}

- (ASHEntity *)addComponent:(id)component
{
    Class componentClass = [component class];
    NSString * componentClassKey = NSStringFromClass(componentClass);
    
    if(components[componentClassKey] != nil)
    {
        [self removeComponent:componentClass];
    }
    
    components[componentClassKey] = component;
    
    [componentAdded dispatchWithObject:self
                            withObject:componentClass];
    return self;
}

- (id)removeComponent:(Class)componentClass
{
    id component = components[NSStringFromClass(componentClass)];
   
    if(component != nil)
    {
        [components removeObjectForKey:NSStringFromClass(componentClass)];
        [componentRemoved dispatchWithObject:self 
                                  withObject:componentClass];
        return component;
    }
    
    return nil;
}

- (id)getComponent:(Class)componentClass
{
    return components[NSStringFromClass(componentClass)];
}

- (NSArray *)allComponents
{
    return components.allValues;
}

- (BOOL)hasComponent:(Class)componentClass
{    
    return components[NSStringFromClass(componentClass)] != nil;
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)value
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
