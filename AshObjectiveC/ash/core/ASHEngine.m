
#import "ASHEngine.h"
#import "ASHEntityList.h"
#import "ASHSystemList.h"
#import "ASHSystem.h"
#import "ASHFamily.h"
#import "ASHComponentMatchingFamily.h"

@implementation ASHEngine
{
    ASHEntityList * entities;
    ASHSystemList * systems;
    NSMutableDictionary * families;
}

@synthesize updating;
@synthesize updateComplete;

@synthesize familyClass;

- (id)init
{
    self = [super init];
    
    if(self != nil)
    {
        entities = [[ASHEntityList alloc] init];
        systems = [[ASHSystemList alloc] init];
        families = [NSMutableDictionary dictionary];
        updateComplete = [[ASHSignal0 alloc] init];
        familyClass = ASHComponentMatchingFamily.class;
    }
    
    return self;
}

- (void)addEntity:(ASHEntity *)entity
{
    [entities addEntity:entity];
    [entity.componentAdded addListener:self 
                                action:@selector(componentAdded:componentClass:)];
    [entity.componentRemoved addListener:self
                                  action:@selector(componentRemoved:componentClass:)];
    for (NSString * nodeKey in families)
    {
        id <ASHFamily> family = families[nodeKey];
        [family newEntity:entity];
    }
}

- (void)removeEntity:(ASHEntity *)entity
{
    [entity.componentAdded removeListener:self 
                                   action:@selector(componentAdded:componentClass:)];
    [entity.componentRemoved removeListener:self
                                     action:@selector(componentRemoved:componentClass:)];
    for (NSString * nodeKey in families) 
    {
        id <ASHFamily> family = families[nodeKey];
        [family removeEntity:entity];
    }
    [entities removeEntity:entity];
}

- (void)removeAllEntities
{
    while (entities.head != nil)
    {
        [self removeEntity:entities.head];
    }
}

- (NSArray *)allEntities
{
    NSMutableArray * entityList = NSMutableArray.array;
    
    for (ASHEntity * entity = entities.head; entity != nil; entity = entity.next)
    {
        [entityList addObject:entity];
    }
    
    return entityList;
}

- (void)componentAdded:(ASHEntity *)entity
        componentClass:(Class)componentClass
{
    for (NSString * nodeKey in families) 
    {
        id <ASHFamily>  family = families[nodeKey];
        [family componentAddedToEntity:entity
                        componentClass:componentClass];
    }
}

- (void)componentRemoved:(ASHEntity *)entity
          componentClass:(Class)componentClass
{
    for (NSString * nodeKey in families)
    {
        id <ASHFamily>  family = families[nodeKey];
        [family componentRemovedFromEntity:entity
                            componentClass:componentClass];
    }
}

- (ASHNodeList *)getNodeList:(Class)nodeClass
{
    NSString * nodeClassKey = NSStringFromClass(nodeClass);
    id <ASHFamily> family = families[nodeClassKey];
    
    if(family != nil)
    {
        return family.nodeList;
    }
    
    family = [(ASHComponentMatchingFamily *)[familyClass alloc] initWithNodeClass:nodeClass
                                                                        engine:self];
    
    families[nodeClassKey] = family;

    ASHEntity * entity = nil;
    
    for (entity = entities.head; entity != nil; entity = entity.next) 
    {
        [family newEntity:entity];
    }
        
    return family.nodeList;
}

- (void)releaseNodeList:(Class)nodeClass
{
    NSString * nodeClassKey = NSStringFromClass(nodeClass);
    id <ASHFamily> family = [families objectForKey:nodeClassKey];
    
    if(family != nil)
    {
        [family cleanUp];
    }
    
    [families removeObjectForKey:nodeClassKey];
}

- (void)addSystem:(ASHSystem *)system
         priority:(NSInteger)priority
{
    system.priority = priority;
    [system addToEngine:self];
    [systems addSystem:system];
}

- (ASHSystem *)getSystem:(Class)type
{
    return [systems getSystem:type];
}

- (NSArray *)allSystems
{
    NSMutableArray * systemList = [NSMutableArray array];
    
    for (ASHSystem * system = systems.head; system != nil; system = system.next)
    {
        [systemList addObject:system];
    }
    
    return systemList;
}

- (void)removeSystem:(ASHSystem *)system
{
    [systems removeSystem:system];
    [system removeFromEngine:self];
}

- (void)removeAllSystems
{
    while(systems.head != nil)
    {
        [self removeSystem:systems.head];
    }
}

- (void)update:(double)time
{
    updating = YES;
    
    for (ASHSystem * system = systems.head; system != nil; system = system.next)
    {
        [system update:time];
    }
    
    updating = NO;
    
    [updateComplete dispatch];
}

@end
