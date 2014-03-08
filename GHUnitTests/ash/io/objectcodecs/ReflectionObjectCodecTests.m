#import <GHUnitIOS/GHUnit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "MockReflectionObject.h"
#import "ASHCodecManager.h"
#import "ASHReflectionObjectCodec.h"
#import "ASHValueCodec.h"

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
    _object.pointVariable = CGPointMake(2, 3);
    _object.rectVariable = CGRectMake(1, 2, 3, 4);
    ASHCodecManager * codecManager = [[ASHCodecManager alloc] init];
    ASHReflectionObjectCodec * encoder = [[ASHReflectionObjectCodec alloc] init];
    [codecManager addCustomCodec:[[ASHReflectionObjectCodec alloc] init]
                            type:[NSValue class]];

    //// testing
    [codecManager addCustomCodec:[[ASHValueCodec alloc] init]
                            type:[NSValue class]];
    ////
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
    assertThat(_encoded[propertiesKey][@"booleanVariable"][valueKey], equalToBool(_object.booleanVariable));
}

- (void)testEncodingReturnsStringVariable
{
    assertThat(_encoded[propertiesKey][@"stringVariable"][valueKey], equalTo(_object.stringVariable));
}

- (void)testEncodingReturnsReflectableObjectVariable
{
    NSLog(@"%@", _encoded);
    assertThat(_encoded[propertiesKey][@"pointVariable"][typeKey], equalTo(NSStringFromClass([NSValue class])));
}




@end