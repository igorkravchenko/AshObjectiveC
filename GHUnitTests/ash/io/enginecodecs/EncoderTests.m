
#import <GHUnitIOS/GHUnit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <objc/runtime.h>
#import "ASHObjectEngineCodec.h"
#import "ASHEngine.h"
#import "MockPoint.h"
#import "MockRectangle.h"
#import "ASHObjectCodec.h"
#import "ASHEngineEncoder.h"
#import "MockHelpers.h"

@interface EncoderTests : GHAsyncTestCase

@property (nonatomic, readwrite) SEL currentCall;

@end

@implementation EncoderTests
{
    ASHObjectEngineCodec * _endec;
    ASHEngine * _engine;
    MockPoint * _firstPoint;
    MockPoint * _secondPoint;
    MockRectangle * _rectangle;
    id _encodedData;
}

- (void)createEncoder
{
    _endec = [[ASHObjectEngineCodec alloc] init];
    _engine = [[ASHEngine alloc] init];
    _firstPoint = [MockPoint pointWithX:1 y:2];
    _secondPoint = [MockPoint pointWithX:3 y:4];
    _rectangle = [MockRectangle rectangleWithX:5 y:6 width:7 height:8];
    ASHEntity * entity = [[ASHEntity alloc] init];
    entity.name = @"first";
    [entity addComponent:_firstPoint];
    [_engine addEntity:entity];
    entity = [[ASHEntity alloc] init];
    entity.name = @"second";
    [entity addComponent:_firstPoint];
    [entity addComponent:_rectangle];
    [_engine addEntity:entity];
    entity = [[ASHEntity alloc] init];
    entity.name = @"third";
    [entity addComponent:_secondPoint];
    [_engine addEntity:entity];
    _encodedData = [_endec encodeEngine:_engine];
}

- (void)deleteEncoder
{
    _endec = nil;
    _engine = nil;
    _firstPoint = nil;
    _secondPoint = nil;
    _rectangle = nil;
}

- (void)setUp
{
    [self createEncoder];
}

- (void)tearDown
{
    [self deleteEncoder];
}

- (void)testEncodedDataHasEntitiesProperty
{
    assertThat(_encodedData[entitiesKey], isNot(nilValue()));
}

- (void)testEncodedDataHasCorrectNumberOfEntities
{
    assertThat(_encodedData[entitiesKey], instanceOf([NSArray class]));
    assertThatInteger([_encodedData[entitiesKey] count], equalToInteger(3));
}

- (void)testEntityNamesAreCorrectlyEncoded
{
    NSArray * names = @[
            _encodedData[entitiesKey][0][nameKey],
            _encodedData[entitiesKey][1][nameKey],
            _encodedData[entitiesKey][2][nameKey],
    ];
    assertThat(names, hasItems(@"first", @"second", nil));
}

- (void)testEntitiesCorrectlyShareComponents
{
    id first;
    id second;
    id third;

    for (id entity in _encodedData[entitiesKey])
    {
        if([entity[nameKey] isEqual:@"first"])
        {
            first = entity;
        }
        else if([entity[nameKey] isEqual:@"second"])
        {
            second = entity;
        }
        else
        {
            third = entity;
        }
    }

    assertThat(second[componentsKey], hasItems(first[componentsKey][0], nil));
}

- (void)testEntitiesHaveCorrectNumberOfComponents
{
    id first;
    id second;
    id third;

    for (id entity in _encodedData[entitiesKey])
    {
        if([entity[nameKey] isEqual:@"first"])
        {
            first = entity;
        }
        else if([entity[nameKey] isEqual:@"second"])
        {
            second = entity;
        }
        else
        {
            third = entity;
        }
    }

    assertThat(first[componentsKey], hasCountOf(1));
    assertThat(second[componentsKey], hasCountOf(2));
    assertThat(third[componentsKey], hasCountOf(1));
}

- (void)testEncodedDataHasComponentsProperty
{
    assertThat(_encodedData[componentsKey], isNot(nilValue()));
}

- (void)testEncodedDataHasAllComponents
{
    assertThat(_encodedData[componentsKey], hasCountOf(3));
}

- (void)testFirstEntityHasCorrectComponents
{
    id first;
    for (id entity in _encodedData[entitiesKey])
    {
        if([entity[nameKey] isEqual:@"first"])
        {
            first = entity;
            break;
        }
    }

    NSNumber * pointID = first[componentsKey][0];
    id pointEncoded;
    for (id component in _encodedData[componentsKey])
    {
        if([component[idKey] isEqual:pointID])
        {
            pointEncoded = component;
            break;
        }
    }
    assertThat(pointEncoded[typeKey], equalTo(NSStringFromClass([MockPoint class])));
    assertThat(pointEncoded[propertiesKey][@"x"][valueKey], equalToFloat(_firstPoint.x));
    assertThat(pointEncoded[propertiesKey][@"y"][valueKey], equalToFloat(_firstPoint.y));
}

- (void)testSecondEntityHasCorrectComponents
{
    id second;
    for (id entity in _encodedData[entitiesKey])
    {
        if([entity[nameKey] isEqual:@"second"])
        {
            second = entity;
            break;
        }
    }

    id pointEncoded;
    id rectangleEncoded;
    for (NSNumber * iD in second[componentsKey])
    {
        for (id component in _encodedData[componentsKey])
        {
            if([component[idKey] isEqual:iD])
            {
                if([component[typeKey] isEqual:NSStringFromClass([MockPoint class])])
                {
                    pointEncoded = component;
                }
                else
                {
                    rectangleEncoded = component;
                }
            }
        }
    }

    assertThat(pointEncoded[typeKey], equalTo(NSStringFromClass([MockPoint class])));
    assertThat(pointEncoded[propertiesKey][@"x"][valueKey], equalToFloat(_firstPoint.x));
    assertThat(pointEncoded[propertiesKey][@"y"][valueKey], equalToFloat(_firstPoint.y));

    assertThat(rectangleEncoded[typeKey], equalTo(NSStringFromClass([MockRectangle class])));
    assertThat(rectangleEncoded[propertiesKey][@"x"][valueKey], equalToFloat(_rectangle.x));
    assertThat(rectangleEncoded[propertiesKey][@"y"][valueKey], equalToFloat(_rectangle.y));
    assertThat(rectangleEncoded[propertiesKey][@"width"][valueKey], equalToFloat(_rectangle.width));
    assertThat(rectangleEncoded[propertiesKey][@"height"][valueKey], equalToFloat(_rectangle.height));
}

- (void)testEntityHasCorrectComponents
{
    id third;
    for (id entity in _encodedData[entitiesKey])
    {
        if ([entity[nameKey] isEqual:@"third"])
        {
            third = entity;
            break;
        }
    }

    NSNumber * pointId = third[componentsKey][0];
    id pointEncoded;
    for (id component in _encodedData[componentsKey])
    {
        if([component[idKey] isEqual:pointId])
        {
            pointEncoded = component;
            break;
        }
    }

    assertThat(pointEncoded[typeKey], equalTo(NSStringFromClass([MockPoint class])));
    assertThat(pointEncoded[propertiesKey][@"x"][valueKey], equalToFloat(_secondPoint.x));
    assertThat(pointEncoded[propertiesKey][@"y"][valueKey], equalToFloat(_secondPoint.y));
}

- (void)testEncodingTriggersCompleteSignal
{
    [super prepare];
    self.currentCall = _cmd;
    [_endec.encodeComplete addListener:self
                                action:@selector(handleCall:)];
    _encodedData = [_endec encodeEngine:_engine];

    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)handleCall:(ASHEngine *)engine
{
    [super notify:kGHUnitWaitStatusSuccess
      forSelector:self.currentCall];
}

@end