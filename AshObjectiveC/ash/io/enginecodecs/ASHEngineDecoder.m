#import "ASHEngineDecoder.h"
#import "ASHCodecManager.h"
#import "ASHEngine.h"
#import "ASHObjectCodec.h"

static NSString * const componentsKey = @"components";
static NSString * const entitiesKey = @"entities";
static NSString * const idKey = @"id";
static NSString * const nameKey = @"name";

@implementation ASHEngineDecoder
{
    ASHCodecManager * _codecManager;
    NSMutableDictionary * _componentMap;
    NSMutableDictionary * _encodedComponentMap;
}

- (instancetype)initWithCodecManager:(ASHCodecManager *)codecManager
{
    self = [super init];
    if (self)
    {
        _codecManager = codecManager;
        _componentMap = [NSMutableDictionary dictionary];
        _encodedComponentMap = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)reset
{
    _componentMap = [NSMutableDictionary dictionary];
    _encodedComponentMap = [NSMutableDictionary dictionary];
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
        _encodedComponentMap[encodedComponent[idKey]] = encodedComponent;
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
        if(_componentMap[componentId])
        {
            NSDictionary * newComponent = _componentMap[componentId];
            if(newComponent)
            {
                Class type = [newComponent class];
                NSObject * existingComponent = [entity getComponent:type];
                if(existingComponent)
                {
                    [_codecManager decodeIntoComponent:existingComponent
                                                object:_encodedComponentMap[componentId]];
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
        if(_componentMap[componentId])
        {
            [entity addComponent:_componentMap[componentId]];
        }
    }

    return entity;
}

- (void)decodeComponent:(NSDictionary *)encodedComponent
{
    Class type = NSClassFromString(encodedComponent[typeKey]);
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:(id)type];
    if(codec)
    {
        _componentMap[encodedComponent[idKey]] = [_codecManager decodeComponent:encodedComponent];
    }
}


@end












