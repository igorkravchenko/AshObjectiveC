
#import "ASHEngine.h"
#import "ASHEntityList.h"
#import "ASHSystemList.h"
#import "ASHSystem.h"
#import "ASHFamily.h"
#import "ASHComponentMatchingFamily.h"

@implementation ASHEngine
{
    NSMutableDictionary * entityNames;
    ASHEntityList * entityList;
    ASHSystemList * systemList;
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
        entityList = [[ASHEntityList alloc] init];
        entityNames = [NSMutableDictionary dictionary];
        systemList = [[ASHSystemList alloc] init];
        families = [NSMutableDictionary dictionary];
        updateComplete = [[ASHSignal0 alloc] init];
        familyClass = ASHComponentMatchingFamily.class;
    }
    
    return self;
}

- (void)addEntity:(ASHEntity *)entity
{
    if(entityNames[entity.name] != nil)
    {
        @throw [NSException exceptionWithName:nil
                                       reason:[NSString stringWithFormat:@"The entity name %@ is already in use by another entity.", entity.name]
                                     userInfo:nil];
    }

    [entityList addEntity:entity];
    entityNames[ entity.name ] = entity;
    [entity.componentAdded addListener:self 
                                action:@selector(componentAdded:componentClass:)];
    [entity.componentRemoved addListener:self
                                  action:@selector(componentRemoved:componentClass:)];
    [entity.nameChanged addListener:self
                             action:@selector(entityNameChanged:oldName:)];
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
    [entity.nameChanged removeListener:self
                                action:@selector(entityNameChanged:oldName:)];
    for (NSString * nodeKey in families) 
    {
        id <ASHFamily> family = families[nodeKey];
        [family removeEntity:entity];
    }
    [entityNames removeObjectForKey:entity.name];
    [entityList removeEntity:entity];
}

- (void)entityNameChanged:(ASHEntity *)entity
                  oldName:(NSString *)oldName
{
    if(entityNames[oldName] == entity)
    {
        [entityNames removeObjectForKey:oldName];
        entityNames[entity.name] = entity;
    }
}

- (ASHEntity *)getEntityByName:(NSString *)name
{
    return entityNames[name];
}

- (void)removeAllEntities
{
    while (entityList.head != nil)
    {
        [self removeEntity:entityList.head];
    }
}

- (NSArray *)allEntities
{
    NSMutableArray * entities = NSMutableArray.array;
    
    for (ASHEntity * entity = entityList.head; entity != nil; entity = entity.next)
    {
        [entities addObject:entity];
    }
    
    return entities;
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
    
    for (entity = entityList.head; entity != nil; entity = entity.next)
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
    [systemList addSystem:system];
}

- (ASHSystem *)getSystem:(Class)type
{
    return [systemList getSystem:type];
}

- (NSArray *)allSystems
{
    NSMutableArray * systems = [NSMutableArray array];
    
    for (ASHSystem * system = systemList.head; system != nil; system = system.next)
    {
        [systems addObject:system];
    }
    
    return systems;
}

- (void)removeSystem:(ASHSystem *)system
{
    [systemList removeSystem:system];
    [system removeFromEngine:self];
}

- (void)removeAllSystems
{
    while(systemList.head != nil)
    {
        ASHSystem * system = systemList.head;
        systemList.head = systemList.head.next;
        system.previous = nil;
        system.next = nil;
        [system removeFromEngine:self];
    }

    systemList.tail = nil;
}

- (void)update:(double)time
{
    updating = YES;
    
    for (ASHSystem * system = systemList.head; system != nil; system = system.next)
    {
        [system update:time];
    }
    
    updating = NO;
    
    [updateComplete dispatch];
}

@end
