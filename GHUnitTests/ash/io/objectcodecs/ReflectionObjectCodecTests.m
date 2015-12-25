
#import "MockReflectionObject.h"
#import "ASHCodecManager.h"
#import "ASHReflectionObjectCodec.h"
#import "MockPoint.h"
#import "MockRectangle.h"

@interface ReflectionObjectCodecTests : GHTestCase
@end

@implementation ReflectionObjectCodecTests
{
    MockReflectionObject * _object;
    NSDictionary * _encoded;
    id _decoded;
}

- (void)createReflection
{
    _object = [[MockReflectionObject alloc] init];
    _object.intVariable = -4;
    _object.uintVariable = 27;
    _object.numberVariable = 23.678f;
    _object.stringVariable = @"A test string";
    _object.booleanVariable = YES;
    _object.fullAccessor = 13;
    _object.pointVariable = [MockPoint pointWithX:2 y:3];
    _object.rectVariable = [MockRectangle rectangleWithX:1 y:2 width:3 height:4];
    ASHCodecManager * codecManager = [[ASHCodecManager alloc] init];
    [codecManager addCustomCodec:[[ASHReflectionObjectCodec alloc] init]
                            type:[MockPoint class]];
    ASHReflectionObjectCodec * encoder = [[ASHReflectionObjectCodec alloc] init];

    _encoded = [encoder encode:_object
                  codecManager:codecManager];
    _decoded = [encoder decode:_encoded
                  codecManager:codecManager];
}

- (void)clearReflection
{
    _object = nil;
    _encoded = nil;
    _decoded = nil;
}

- (void)setUp
{
    [self createReflection];
}

- (void)tearDown
{
    [self clearReflection];
}

- (void)testEncodingReturnsCorrectType
{
    assertThat(_encoded[typeKey], equalTo(NSStringFromClass([MockReflectionObject class])));
}

- (void)testEncodingReturnsIntVariable
{
    assertThat(_encoded[propertiesKey][@"intVariable"][valueKey], equalToInteger(_object.intVariable));
}

- (void)testEncodingReturnsUintVariable
{
    assertThat(_encoded[propertiesKey][@"uintVariable"][valueKey], equalToUnsignedInteger(_object.uintVariable));
}

- (void)testEncodingReturnsNumberVariable
{
    assertThat(_encoded[propertiesKey][@"numberVariable"][valueKey], equalToFloat(_object.numberVariable));
}

- (void)testEncodingReturnsBooleanVariable
{
    assertThat(_encoded[propertiesKey][@"booleanVariable"][valueKey], _object.booleanVariable ? isTrue() : isFalse());
}

- (void)testEncodingReturnsStringVariable
{
    assertThat(_encoded[propertiesKey][@"stringVariable"][valueKey], equalTo(_object.stringVariable));
}

- (void)testEncodingReturnsReflectableObjectVariable
{
    assertThat(_encoded[propertiesKey][@"pointVariable"][typeKey], equalTo(NSStringFromClass([MockPoint class])));
    assertThat(_encoded[propertiesKey][@"pointVariable"][propertiesKey][@"x"][valueKey], equalToFloat(_object.pointVariable.x));
    assertThat(_encoded[propertiesKey][@"pointVariable"][propertiesKey][@"y"][valueKey], equalToFloat(_object.pointVariable.y));
}

- (void)testEncodingReturnsNullObjectForReflectableNullVariable
{
    assertThat(_encoded[propertiesKey][@"point2Variable"][valueKey], equalTo([NSNull null]));
}

- (void)testEncodingReturnsNilForNonReflectableVariable
{
    assertThat(_encoded[propertiesKey][@"rectVariable"][valueKey], equalTo(nil));
}
// TODO: ask Richard about this test
- (void)testEncodingDoesntReturnsNullForNonReflectableNullVariable
{
    assertThat(_encoded[propertiesKey][@"rect2Variable"][valueKey], equalTo([NSNull null]));
}

- (void)testDecodingReturnsCorrectType
{
    assertThat(_decoded, instanceOf([MockReflectionObject class]));
}

- (void)testDecodingReturnsIntVariable
{
    assertThatInteger([_decoded intVariable], equalToInteger(_object.intVariable));
}

- (void)testDecodingReturnsUintVariable
{
    assertThatUnsignedInteger([_decoded uintVariable], equalToUnsignedInteger(_object.uintVariable));
}

- (void)testDecodingReturnsBooleanVariable
{
    assertThatBool([_decoded booleanVariable], _object.booleanVariable ? isTrue() : isFalse());
}

- (void)testDecodingReturnsStringVariable
{
    assertThat([_decoded stringVariable], equalTo(_object.stringVariable));
}

- (void)testDecodingReturnsReflectableObjectVariable
{
    assertThat([_decoded pointVariable], instanceOf([MockPoint class]));
    assertThatFloat([_decoded pointVariable].x, equalToFloat(_object.pointVariable.x));
    assertThatFloat([_decoded pointVariable].y, equalToFloat(_object.pointVariable.y));
}

- (void)testDecodingReturnsFullAccessor
{
    assertThatInteger([_decoded fullAccessor], equalToInteger(_object.fullAccessor));
}

@end