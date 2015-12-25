
#import "ASHComponentMatchingFamily.h"
#import "ASHNodePool.h"
#import "ASHMacro.h"
#import <objc/runtime.h>

@implementation ASHComponentMatchingFamily
{
    Class nodeClass;
    NSMapTable * components;
    ASHNodePool * nodePool;
    __weak ASHEngine * game;
    ASHNodeList * nodes;
    NSMapTable * entities;
}

- (id)initWithNodeClass:(Class)aNodeClass
                   engine:(ASHEngine *)engine
{
    self = [super init];
    
    if(self != nil)
    {
        nodeClass = aNodeClass;
        game = engine;
        [self create];
    }
    
    return self;
}

- (void)create
{
    nodePool = [[ASHNodePool alloc] initWithNodeClass:nodeClass
                                           components:components];
    nodes = [[ASHNodeList alloc] init];
    entities = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaquePersonality valueOptions:NSPointerFunctionsStrongMemory];
    components = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaquePersonality valueOptions:NSPointerFunctionsStrongMemory];
    u_int count;
    objc_property_t * properties = class_copyPropertyList(nodeClass, &count);
    
    for (NSUInteger i = 0; i < count; i++)
    {
         NSString * propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        
        if (!([propertyName isEqual:@"entity"] &&
            [propertyName isEqual:@"previous"] &&
            [propertyName isEqual:@"next"])) 
        {
            const char * propType = property_getTypeString(properties[i]);
            NSString * stringClass =
            [[[NSString stringWithCString:propType 
                                  encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"T@" 
              withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [components setObject:propertyName forKey:NSClassFromString(stringClass)];
        }
    }
    
    free(properties);
}

- (ASHNodeList *)nodeList
{
    return nodes;
}

- (void)newEntity:(ASHEntity *)entity
{
    [self addIfMatch:entity];
}

- (void)componentAddedToEntity:(ASHEntity *)entity
                componentClass:(Class)componentClass
{
    [self addIfMatch:entity];
}

- (void)componentRemovedFromEntity:(ASHEntity *)entity
                    componentClass:(Class)componentClass
{
    if([components objectForKey:componentClass] != nil)
    {
        [self removeIfMatch:entity];
    }
}

- (void)removeEntity:(ASHEntity *)entity
{
    [self removeIfMatch:entity];
}

- (void)addIfMatch:(ASHEntity *)entity
{
    if([entities objectForKey:entity] == nil)
    {
        Class componentClass;
        
        for (componentClass in components)
        {
            if(![entity hasComponent:componentClass])
            {                
                return;   
            }
        }
                
        ASHNode * node = [nodePool getNode];
        node->entity = entity;
                
        for (componentClass in components)
        {
            [node setValue:[entity getComponent:componentClass]
                    forKey:[components objectForKey:componentClass]];
        }
        
        [entities setObject:node forKey:entity];
        [nodes addNode:node];        
    }
}

- (void)removeIfMatch:(ASHEntity *)entity
{

    if([entities objectForKey:entity] != nil)
    {
        ASHNode * node = [entities objectForKey:entity];
        [entities removeObjectForKey:entity];
        [nodes removeNode:node];
        if(game.updating)
        {
            [nodePool cacheNode:node];
            [game.updateComplete addListener:self 
                                      action:@selector(releaseNodePoolCache)];
        }
        else 
        {
            [nodePool disposeNode:node];
        }
    }
}

- (void)releaseNodePoolCache
{
    [game.updateComplete removeListener:self 
                                 action:@selector(releaseNodePoolCache)];
    [nodePool releaseCache];
}

- (void)cleanUp
{
    for(ASHNode * node = nodes->head; node != nil; node = node->next)
    {
        [entities removeObjectForKey:node->entity];
    }
    
    [nodes removeAll];
}

@end
