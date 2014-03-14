
#import <GHUnitIOS/GHUnit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <objc/runtime.h>
#import "ASHObjectEngineCodec.h"
#import "ASHEngine.h"
#import "MockComponent1IO.h"
#import "MockComponent2IO.h"
#import "ASHJsonEngineCodec.h"

@interface JsonEngineCodecTests : GHTestCase
@end

@implementation JsonEngineCodecTests
{
    ASHJsonEngineCodec * _endec;
    ASHEngine * _original;
    ASHEngine * _engine;
    MockComponent1IO * _firstComponent1;
    MockComponent1IO * _secondComponent1;
    MockComponent2IO * _onlyComponent2;
    id _encodedData;
}

- (void)setUp
{
    [self createDecoder];
}

- (void)tearDown
{
    [self deleteEncoder];
}

- (void)createDecoder
{
    _endec = [[ASHJsonEngineCodec alloc] init];
    _original = [[ASHEngine alloc] init];
    _firstComponent1 = [[MockComponent1IO alloc] initWithX:1 y:2];
    _firstComponent1.cgPoint = CGPointMake(100, 200);
    _secondComponent1 = [[MockComponent1IO alloc] initWithX:3 y:4];
    _onlyComponent2 = [[MockComponent2IO alloc] initWithX:5 y:6];
    ASHEntity * entity = [[ASHEntity alloc] init];
    entity.name = @"first";
    [entity addComponent:_firstComponent1];
    [_original addEntity:entity];
    entity = [[ASHEntity alloc] init];
    entity.name = @"second";
    [entity addComponent:_firstComponent1];
    [entity addComponent:_onlyComponent2];
    [_original addEntity:entity];
    entity = [[ASHEntity alloc] init];
    entity.name = @"third";
    [entity addComponent:_secondComponent1];
    [_original addEntity:entity];
    _encodedData = [_endec encodeEngine:_original];
    _engine = [[ASHEngine alloc] init];
    [_endec decodeEngine:_encodedData engine:_engine];
}

- (void)deleteEncoder
{
    _endec = nil;
    _original = nil;
    _engine = nil;
    _firstComponent1 = nil;
    _secondComponent1 = nil;
    _onlyComponent2 = nil;
}

- (void)testEncodedDataIsAString
{
    assertThat(_encodedData, instanceOf([NSString class]));
}

- (void)testDecodedHasCorrectEntityNames
{
    NSArray * entities = _engine.allEntities;
    NSMutableArray * names = [entities valueForKey:@"name"];
    assertThat(names, hasItems(@"first", @"second", @"third", nil));
}

- (void)testFirstEntityHasCorrectComponents
{
    NSArray * entities = _engine.allEntities;
    ASHEntity * first;
    for (ASHEntity * entity in entities)
    {
        if([entity.name isEqual:@"first"])
        {
            first = entity;
            break;
        }
    }
    assertThat(first.allComponents, hasCountOf(1));
    MockComponent1IO * component = [first getComponent:[MockComponent1IO class]];
    assertThat(component, isNot(nilValue()));
}

- (void)testSecondEntityHasCorrectComponents
{
    NSArray * entities = _engine.allEntities;
    ASHEntity * second;
    for (ASHEntity * entity in entities)
    {
        if([entity.name isEqual:@"second"])
        {
            second = entity;
            break;
        }
    }
    assertThat(second.allComponents, hasCountOf(2));
    MockComponent1IO * component1 = [second getComponent:[MockComponent1IO class]];
    assertThat(component1, isNot(nilValue()));
    MockComponent2IO * component2 = [second getComponent:[MockComponent2IO class]];
    assertThat(component2, isNot(nilValue()));
}

- (void)testThirdEntityHasCorrectComponents
{
    NSArray * entities = _engine.allEntities;
    ASHEntity * third;
    for (ASHEntity * entity in entities)
    {
        if([entity.name isEqual:@"third"])
        {
            third = entity;
            break;
        }
    }
    assertThat(third.allComponents, hasCountOf(1));
    MockComponent1IO * component = [third getComponent:[MockComponent1IO class]];
    assertThat(component, isNot(nilValue()));
}

- (void)testEntitiesCorrectlyShareComponents
{
    NSArray * entities = _engine.allEntities;
    ASHEntity * first;
    ASHEntity * second;
    for (ASHEntity * entity in entities)
    {
        if([entity.name isEqual:@"first"])
        {
            first = entity;
        }
        else if([entity.name isEqual:@"second"])
        {
            second = entity;
        }
    }
    assertThat([first getComponent:[MockComponent1IO class]], sameInstance([second getComponent:[MockComponent1IO class]]));
}

- (void)testFirstEntityComponentsHaveCorrectValues
{
    NSArray * entities = _engine.allEntities;
    ASHEntity * first;
    for (ASHEntity * entity in entities)
    {
        if([entity.name isEqual:@"first"])
        {
            first = entity;
            break;
        }
    }

    MockComponent1IO * component = [first getComponent:[MockComponent1IO class]];
    assertThatFloat(component.x, equalToFloat(_firstComponent1.x));
    assertThatFloat(component.y, equalToFloat(_firstComponent1.y));
}

- (void)testSecondEntityComponentsHaveCorrectValues
{
    NSArray * entities = _engine.allEntities;
    ASHEntity * second;
    for (ASHEntity * entity in entities)
    {
        if([entity.name isEqual:@"second"])
        {
            second = entity;
            break;
        }
    }

    MockComponent1IO * component1 = [second getComponent:[MockComponent1IO class]];
    assertThatFloat(component1.x, equalToFloat(_firstComponent1.x));
    assertThatFloat(component1.y, equalToFloat(_firstComponent1.y));
    MockComponent1IO * component2 = [second getComponent:[MockComponent2IO class]];
    assertThatFloat(component2.x, equalToFloat(_onlyComponent2.x));
    assertThatFloat(component2.y, equalToFloat(_onlyComponent2.y));
}

- (void)testThirdEntityComponentsHaveCorrectValues
{
    NSArray * entities = _engine.allEntities;
    ASHEntity * third;
    for (ASHEntity * entity in entities)
    {
        if([entity.name isEqual:@"third"])
        {
            third = entity;
            break;
        }
    }

    MockComponent1IO * component1 = [third getComponent:[MockComponent1IO class]];
    assertThatFloat(component1.x, equalToFloat(_secondComponent1.x));
    assertThatFloat(component1.y, equalToFloat(_secondComponent1.y));
}



@end