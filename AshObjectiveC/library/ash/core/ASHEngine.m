
#import "ASHEngine.h"
#import "ASHEntityList.h"
#import "ASHSystemList.h"
#import "ASHSystem.h"
#import "ASHFamily.h"
#import "ASHComponentMatchingFamily.h"

@implementation ASHEngine
{
    NSMapTable * entityNames;
    ASHEntityList * entityList;
    ASHSystemList * systemList;
    NSMapTable * families;
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
        entityNames = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsStrongMemory];
        systemList = [[ASHSystemList alloc] init];
        families = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaquePersonality valueOptions:NSPointerFunctionsStrongMemory];
        updateComplete = [[ASHSignal0 alloc] init];
        familyClass = ASHComponentMatchingFamily.class;
    }
    
    return self;
}

- (void)addEntity:(ASHEntity *)entity
{
    if([entityNames objectForKey:entity.name] != nil)
    {
        @throw [NSException exceptionWithName:[NSStringFromClass(self.class) stringByAppendingString:@"Exception"]
                                       reason:[NSString stringWithFormat:@"The entity name %@ is already in use by another entity.", entity.name]
                                     userInfo:nil];
    }

    [entityList addEntity:entity];
    [entityNames setObject:entity forKey:entity.name];
    [entity.componentAdded addListener:self 
                                action:@selector(componentAdded:componentClass:)];
    [entity.componentRemoved addListener:self
                                  action:@selector(componentRemoved:componentClass:)];
    [entity.nameChanged addListener:self
                             action:@selector(entityNameChanged:oldName:)];
    for (Class nodeClass in families)
    {
        id <ASHFamily> family = [families objectForKey:nodeClass];
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
    for (Class nodeClass in families)
    {
        id <ASHFamily> family = [families objectForKey:nodeClass];
        [family removeEntity:entity];
    }
    [entityNames removeObjectForKey:entity.name];
    [entityList removeEntity:entity];
}

- (void)entityNameChanged:(ASHEntity *)entity
                  oldName:(NSString *)oldName
{
    if([entityNames objectForKey:oldName] == entity)
    {
        [entityNames removeObjectForKey:oldName];
        [entityNames setObject:entity forKey:entity.name];
    }
}

- (ASHEntity *)getEntityByName:(NSString *)name
{
    return [entityNames objectForKey:name];
}

- (void)removeAllEntities
{
    while (entityList->head != nil)
    {
        [self removeEntity:entityList->head];
    }
}

- (NSArray *)allEntities
{
    NSMutableArray * entities = NSMutableArray.array;
    
    for (ASHEntity * entity = entityList->head; entity != nil; entity = entity->next)
    {
        [entities addObject:entity];
    }
    
    return entities;
}

- (void)componentAdded:(ASHEntity *)entity
        componentClass:(Class)componentClass
{
    for (Class nodeClass in families)
    {
        id <ASHFamily> family = [families objectForKey:nodeClass];
        [family componentAddedToEntity:entity
                        componentClass:componentClass];
    }
}

- (void)componentRemoved:(ASHEntity *)entity
          componentClass:(Class)componentClass
{
    for (Class nodeClass in families)
    {
        id <ASHFamily> family = [families objectForKey:nodeClass];
        [family componentRemovedFromEntity:entity
                            componentClass:componentClass];
    }
}

- (ASHNodeList *)getNodeList:(Class)nodeClass
{
    id <ASHFamily> family = [families objectForKey:nodeClass];

    if(family != nil)
    {
        return family.nodeList;
    }
    
    family = [(ASHComponentMatchingFamily *)[familyClass alloc] initWithNodeClass:nodeClass
                                                                           engine:self];

    [families setObject:family forKey:nodeClass];

    ASHEntity * entity = nil;
    
    for (entity = entityList->head; entity != nil; entity = entity->next)
    {
        [family newEntity:entity];
    }
        
    return family.nodeList;
}

- (void)releaseNodeList:(Class)nodeClass
{
    id <ASHFamily> family = [families objectForKey:nodeClass];

    if(family != nil)
    {
        [family cleanUp];
    }
    
    [families removeObjectForKey:nodeClass];
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
    
    for (ASHSystem * system = systemList->head; system != nil; system = system->next)
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
        ASHSystem * system = systemList->head;
        systemList->head = systemList->head->next;
        system->previous = nil;
        system->next = nil;
        [system removeFromEngine:self];
    }

    systemList->tail = nil;
}

- (void)update:(double)time
{
    updating = YES;
    
    for (ASHSystem * system = systemList->head; system != nil; system = system->next)
    {
        [system update:time];
    }
    
    updating = NO;
    
    [updateComplete dispatch];
}

@end
