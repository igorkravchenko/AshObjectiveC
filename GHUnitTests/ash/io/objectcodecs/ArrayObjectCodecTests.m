#import "ASHClassObjectCodec.h"
#import "ASHCodecManager.h"
#import "ASHArrayObjectCodec.h"
#import <GHUnitIOS/GHUnit.h>
#import <objc/runtime.h>

@interface ArrayObjectCodecTests : GHTestCase
@end

@implementation ArrayObjectCodecTests
{
    ASHArrayObjectCodec * _codec;
    ASHCodecManager * _codecManager;
}

- (void)setUp
{
    [self createCodec];
}

- (void)tearDown
{
    [self deleteCodec];
}


- (void)createCodec
{
    _codecManager = [[ASHCodecManager alloc] init];
    _codec = [[ASHArrayObjectCodec alloc] init];
}

- (void)deleteCodec
{
    _codec = nil;
}

- (void)testEncodesArrayWithCorrectType
{
    NSArray * input = @[@7, @6, @5, @4, @3];
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    assertThat(encoded[typeKey], equalTo(NSStringFromClass([NSArray class])));

}

- (void)testEncodesArrayWithCorrectProperties
{
    NSArray * input = @[@7, @6, @5, @4, @3];
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    assertThatUnsignedInteger([encoded[valuesKey] count], equalToUnsignedInteger(5));
    assertThat(encoded[valuesKey][0][valueKey], equalTo(@7));
    assertThat(encoded[valuesKey][1][valueKey], equalTo(@6));
    assertThat(encoded[valuesKey][2][valueKey], equalTo(@5));
    assertThat(encoded[valuesKey][3][valueKey], equalTo(@4));
    assertThat(encoded[valuesKey][4][valueKey], equalTo(@3));
}

- (void)testEncodesMutableArrayWithCorrectType
{
    NSMutableArray * input = @[@7, @6, @5, @4, @3].mutableCopy;
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    assertThat(encoded[typeKey], equalTo(NSStringFromClass([NSMutableArray class])));
}

- (void)testEncodesMutableArrayWithCorrectProperties
{
    NSMutableArray * input = @[@7, @6, @5, @4, @3].mutableCopy;
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    assertThatUnsignedInteger([encoded[valuesKey] count], equalToUnsignedInteger(5));
    assertThat(encoded[valuesKey][0][valueKey], equalTo(@7));
    assertThat(encoded[valuesKey][1][valueKey], equalTo(@6));
    assertThat(encoded[valuesKey][2][valueKey], equalTo(@5));
    assertThat(encoded[valuesKey][3][valueKey], equalTo(@4));
    assertThat(encoded[valuesKey][4][valueKey], equalTo(@3));
}

- (void)testDecodesArrayWithCorrectType
{
    NSArray * input = @[@7, @6, @5, @4, @3];
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    id decoded = [_codec decode:encoded
                   codecManager:_codecManager];
    assertThat(decoded, instanceOf([NSArray class]));
}

- (void)testDecodesArrayWithCorrectProperties
{
    NSArray * input = @[@7, @6, @5, @4, @3];
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    id decoded = [_codec decode:encoded
                  codecManager:_codecManager];
    assertThatBool([decoded isEqualToArray:input.copy], equalToBool(YES));
}

- (void)testDecodesMutableArrayWithCorrectType
{
    NSMutableArray * input = @[@7, @6, @5, @4, @3].mutableCopy;
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    id decoded = [_codec decode:encoded
                   codecManager:_codecManager];
    assertThat(decoded, instanceOf([NSMutableArray class]));
}

- (void)testDecodesVectorWithCorrectProperties
{
    NSMutableArray * input = @[@7, @6, @5, @4, @3].mutableCopy;
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    id decoded = [_codec decode:encoded
                   codecManager:_codecManager];
    assertThatBool([decoded isEqualToArray:input.mutableCopy], equalToBool(YES));
}

@end