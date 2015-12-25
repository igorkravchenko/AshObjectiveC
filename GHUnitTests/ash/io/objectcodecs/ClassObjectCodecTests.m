
#import "ASHClassObjectCodec.h"
#import "ASHCodecManager.h"
#import <objc/runtime.h>


@interface ClassObjectCodecTests : GHTestCase
@end

@implementation ClassObjectCodecTests
{
    ASHClassObjectCodec * _codec;
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
    _codec = [[ASHClassObjectCodec alloc] init];
}

- (void)deleteCodec
{
    _codec = nil;
}

- (void)testEncodesClassWithCorrectType
{
    Class input = [NSDate class];
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    assertThat(encoded[typeKey], equalTo(classKey));

}

- (void)testEncodesClassWithCorrectValue
{
    Class input = [NSDate class];
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    assertThat(encoded[valueKey], equalTo(NSStringFromClass(input)));
}

- (void)testDecodesClassWithCorrectType
{
    Class input = [NSDate class];
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    id decoded = [_codec decode:encoded
                   codecManager:_codecManager];
    assertThatBool(class_isMetaClass(object_getClass(decoded)), isTrue());

}

- (void)testDecodesClassWithCorrectValue
{
    Class input = [NSDate class];
    NSDictionary * encoded = [_codec encode:input
                               codecManager:_codecManager];
    id decoded = [_codec decode:encoded
                   codecManager:_codecManager];


    assertThat(decoded, equalTo(input));
}

@end