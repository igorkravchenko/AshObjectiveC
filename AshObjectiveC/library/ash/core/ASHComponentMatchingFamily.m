
#import "ASHComponentMatchingFamily.h"
#import "ASHNodePool.h"
#import "ASHMacro.h"
#import <objc/runtime.h>

@implementation ASHComponentMatchingFamily
{
    Class nodeClass;
    NSMutableDictionary * components;
    ASHNodePool * nodePool;
    ASHEngine * game;
    ASHNodeList * nodes;
}

@synthesize entities;

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
    entities = [NSMutableDictionary dictionary];
    components = [NSMutableDictionary dictionary];
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
            components[stringClass] = propertyName;
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
    if(components[NSStringFromClass(componentClass)] != nil)
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
    if(entities[@(entity.hash)] == nil)
    {
        NSString * componentClassString = nil;
        
        for (componentClassString in components) 
        {
            if(![entity hasComponent:NSClassFromString(componentClassString)])
            {                
                return;   
            }
        }
                
        ASHNode * node = [nodePool getNode];
        node.entity = entity;
                
        for (componentClassString in components) 
        {
            [node setValue:[entity getComponent:NSClassFromString(componentClassString)] 
                    forKey:components[componentClassString]];
        }
        
        entities[@(entity.hash)] = node;
        [nodes addNode:node];        
    }
}

- (void)removeIfMatch:(ASHEntity *)entity
{
    NSNumber * entityID = @(entity.hash);
    
    if(entities[entityID] != nil)
    {
        ASHNode * node = entities[entityID];
        [entities removeObjectForKey:entityID];
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
    for(ASHNode * node = nodes.head; node != nil; node = node.next)
    {
        [entities removeObjectForKey:@(node.entity.hash)];
        
    }
    
    [nodes removeAll];
}

@end
