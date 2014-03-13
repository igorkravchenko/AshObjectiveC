
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
#import "MockComponent1IO.h"
#import "MockComponent2IO.h"


@interface DecoderTests : GHAsyncTestCase
@end

@implementation DecoderTests
{
    ASHObjectEngineCodec * _endec;
    ASHEngine * _original;
    id _encodedData;
    ASHEngine * _engine;
    MockComponent1IO * _firstComponent1;
    MockComponent1IO * _secondComponent1;
    MockComponent2IO * _onlyComponent2;

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
    _endec = [[ASHObjectEngineCodec alloc] init];
    _original = [[ASHEngine alloc] init];
    _firstComponent1 = [[MockComponent1IO alloc] initWithX:1 y:2];
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
    [_endec decodeEngine:_encodedData
                  engine:_engine];
}

- (void)deleteEncoder
{
    [_endec.decodeComplete removeAll];
    _endec = nil;
    _original = nil;
    _engine = nil;
    _firstComponent1 = nil;
    _secondComponent1 = nil;
    _onlyComponent2 = nil;
}

- (void)testDecodedHasCorrectNumberOfEntities
{
    assertThat(_engine.allEntities, hasCountOf(3));
}

- (void)testDecodedHasCorrectEntityNames
{
    NSArray * entities = _engine.allEntities;
    NSMutableArray * names = [entities valueForKey:@"name"];
    assertThat(names, hasItems(@"first", @"second", @"third", nil));
}


@end