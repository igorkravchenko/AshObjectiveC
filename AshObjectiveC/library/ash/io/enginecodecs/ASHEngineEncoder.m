
#import "ASHEngineEncoder.h"
#import "ASHCodecManager.h"
#import "ASHEngine.h"

@implementation ASHEngineEncoder
{
    ASHCodecManager * _codecManager;
    NSMapTable * _componentEncodingMap;
    NSMutableArray * _encodedEntities;
    NSMutableArray * _encodedComponents;
    NSInteger _nextComponentId;
    NSDictionary * _encoded;
}

- (instancetype)initWithCodecManager:(ASHCodecManager *)codecManager
{
    self = [super init];
    if (self)
    {
        _codecManager = codecManager;
        [self reset];
    }

    return self;
}

- (void)reset
{
    _nextComponentId = 1;
    _encodedEntities = [NSMutableArray array];
    _encodedComponents = [NSMutableArray array];
    _componentEncodingMap = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality | NSMapTableStrongMemory
                                                  valueOptions:NSMapTableObjectPointerPersonality | NSMapTableStrongMemory];
    _encoded = @{entitiesKey : _encodedEntities, componentsKey : _encodedComponents}.mutableCopy;
}

- (NSDictionary *)encodeEngine:(ASHEngine *)engine
{
    NSArray * entities = engine.allEntities;

    for (ASHEntity * entity in entities)
    {
        [self encodeEntity:entity];
    }

    return _encoded;
}

- (void)encodeEntity:(ASHEntity *)entity
{
    NSArray * components = entity.allComponents;
    NSMutableArray * componentIds = [NSMutableArray array];
    for (id component in components)
    {
        NSNumber * encodedComponent = @([self encodeComponent:component]);

        if(encodedComponent.unsignedIntegerValue != 0)
        {
            [componentIds addObject:encodedComponent];
        }
    }

    [_encodedEntities addObject:
                              @{
                                      nameKey: entity.name,
                                      componentsKey : componentIds
                              }];
}

- (NSInteger)encodeComponent:(id)component
{
    if([_componentEncodingMap objectForKey:component])
    {
        return [[_componentEncodingMap objectForKey:component][idKey] integerValue];
    }
    NSMutableDictionary * encoded = [_codecManager encodeComponent:component].mutableCopy;

    if(encoded)
    {
        encoded[idKey] = @(_nextComponentId++);
        [_componentEncodingMap setObject:encoded
                                  forKey:component];
        [_encodedComponents addObject:encoded];

        return [encoded[idKey] integerValue];
    }

    return 0;
}

@end