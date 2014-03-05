#import <__functional_base_03>
#import "ASHEngineDecoder.h"
#import "ASHCodecManager.h"
#import "ASHEngine.h"
#import "ASHObjectCodec.h"

static NSString * const componentsKey = @"components";
static NSString * const entitiesKey = @"entities";
static NSString * const idKey = @"id";
static NSString * const nameKey = @"name";
static NSString * const typeKey = @"type";

@implementation ASHEngineDecoder
{
    ASHCodecManager * _codecManager;
    NSMutableArray * _componentMap;
    NSMutableArray * _encodedComponentMap;
}

- (instancetype)initWithCodecManager:(ASHCodecManager *)codecManager
{
    self = [super init];
    if (self)
    {
        _codecManager = codecManager;
        _componentMap = [NSMutableArray array];
        _encodedComponentMap = [NSMutableArray array];
    }

    return self;
}

- (void)reset
{
    [_componentMap removeAllObjects];
    [_encodedComponentMap removeAllObjects];
}

- (void)decodeEngine:(NSDictionary *)encodedData
              engine:(ASHEngine *)engine
{
    NSArray * components = encodedData[componentsKey];

    for (NSDictionary * encodedComponent in components)
    {
        [self decodeComponent:encodedComponent];
    }

    NSArray * entities = encodedData[entitiesKey];

    for (NSDictionary * encodedEntity in entities)
    {
        [engine addEntity:[self decodeEntity:encodedEntity]];
    }
}

- (void)decodeOverEngine:(NSDictionary *)encodedData
                  engine:(ASHEngine *)engine
{
    NSArray * components = encodedData[componentsKey];
    for (NSDictionary * encodedComponent in components)
    {
        _encodedComponentMap[(NSUInteger)[encodedComponent[idKey] integerValue]] = encodedComponent;
        [self decodeComponent:encodedComponent];
    }

    NSArray * entities = encodedData[entitiesKey];
    for (NSDictionary * encodedEntity in entities)
    {
        NSString * name = encodedEntity[nameKey];
        if(name)
        {
            ASHEntity * existingEntity = [engine getEntityByName:name];
            if (existingEntity)
            {
                [self overlayEntity:existingEntity
                      encodedEntity:encodedEntity];
                continue;
            }
        }
        [engine addEntity:[self decodeEntity:encodedEntity]];
    }
}

- (void)overlayEntity:(ASHEntity *)entity
        encodedEntity:(NSDictionary *)encodedEntity
{
    NSArray * components = encodedEntity[componentsKey];
    for (NSNumber * componentId in components)
    {
        NSInteger compID = componentId.integerValue;
        if(compID >= 0 && compID < components.count)
        {
            NSDictionary * newComponent = _componentMap[(NSUInteger) compID];
            if(newComponent)
            {
                Class type = [newComponent class];
                NSObject * existingComponent = [entity getComponent:type];
                if(existingComponent)
                {
                    [_codecManager decodeIntoComponent:existingComponent
                                                object:_encodedComponentMap[(NSUInteger) compID]];
                }
                else
                {
                    [entity addComponent:newComponent];
                }
            }
        }
    }
}

- (ASHEntity *)decodeEntity:(NSDictionary *)encodedEntity
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    if(encodedEntity[nameKey])
    {
        entity.name = encodedEntity[nameKey];
    }

    NSArray * components = encodedEntity[componentsKey];

    for (NSNumber * componentId in components)
    {
        NSInteger compID = componentId.integerValue;
        if(compID >= 0 && compID < components.count)
        {
            [entity addComponent:_componentMap[(NSUInteger) compID]];
        }
    }

    return entity;
}

/*
private function decodeComponent( encodedComponent : Object ) : void
		{
			var codec : IObjectCodec = codecManager.getCodecForComponent( getDefinitionByName( encodedComponent.type ) );
			if( codec )
			{
				componentMap[encodedComponent.id] = codecManager.decodeComponent( encodedComponent );
			}
		}
 */

- (void)decodeComponent:(NSDictionary *)encodedComponent
{
    Class type = NSClassFromString(encodedComponent[typeKey]);
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:(id)type];
    if(codec)
    {
        _componentMap[(NSUInteger) [encodedComponent[idKey] integerValue]] = [_codecManager decodeComponent:encodedComponent];
    }
}


@end












