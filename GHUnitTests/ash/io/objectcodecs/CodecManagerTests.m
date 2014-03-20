
#import "MockReflectionObject.h"
#import "MockPoint.h"
#import "ASHCodecManager.h"
#import "ASHObjectCodec.h"
#import "ASHReflectionObjectCodec.h"
#import "ASHNativeObjectCodec.h"
#import "ASHClassObjectCodec.h"
#import "ASHArrayObjectCodec.h"
#import "ASHValueObjectCodec.h"
#import <GHUnitIOS/GHUnit.h>

@interface MockCodec : NSObject <ASHObjectCodec>

@end

@implementation MockCodec

- (NSDictionary *)encode:(id)object codecManager:(ASHCodecManager *)codecManager
{
    return nil;
}

- (NSObject *)decode:(NSDictionary *)object codecManager:(ASHCodecManager *)codecManager
{
    return nil;
}

- (void)decodeIntoObject:(NSObject *)target object:(NSDictionary *)object codecManager:(ASHCodecManager *)codecManager
{

}

- (void)decodeIntoProperty:(NSObject *)parent property:(NSString *)property object:(NSDictionary *)object codecManager:(ASHCodecManager *)codecManager
{

}


@end

@interface CodecManagerTests : GHTestCase
@end

@implementation CodecManagerTests
{
    ASHCodecManager * _codecManager;
}

- (void)setUp
{
    [self createStore];
}

- (void)tearDown
{
    [self deleteStore];
}

- (void)createStore
{
    _codecManager = [[ASHCodecManager alloc] init];
}

- (void)deleteStore
{
    _codecManager = nil;
}

- (void)testCodecForObjectReturnsNullByDefault
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForObject:[[MockPoint alloc] init]];
    assertThat(codec, nilValue());
}

- (void)testCodecForComponentReturnsReflectionCodecByDefault
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:[[MockPoint alloc] init]];
    assertThat(codec, instanceOf([ASHReflectionObjectCodec class]));
}

- (void)testCustomCodecReturnedForComponentIfSet
{
    MockCodec * setCodec = [[MockCodec alloc] init];
    [_codecManager addCustomCodec:setCodec
                             type:[MockPoint class]];
    id <ASHObjectCodec> returnedCodec = [_codecManager getCodecForComponent:[[MockPoint alloc] init]];
    assertThat(setCodec, sameInstance(returnedCodec));
}

- (void)testCustomCodecReturnedForObjectIfSet
{
    MockCodec * setCodec = [[MockCodec alloc] init];
    [_codecManager addCustomCodec:setCodec
                             type:[MockPoint class]];
    id <ASHObjectCodec> returnedCodec = [_codecManager getCodecForObject:[[MockPoint alloc] init]];
    assertThat(setCodec, sameInstance(returnedCodec));
}

- (void)testCodecForObjectReturnsNativeCodecForInt
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForObject:@((NSInteger)5)];
    assertThat(codec, instanceOf([ASHNativeObjectCodec class]));
}

- (void)testCodecForComponentReturnsNativeCodecForInt
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:@((NSInteger)5)];
    assertThat(codec, instanceOf([ASHNativeObjectCodec class]));
}

- (void)testCodecForObjectReturnsNativeCodecForUint
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForObject:@((NSUInteger)5)];
    assertThat(codec, instanceOf([ASHNativeObjectCodec class]));
}

- (void)testCodecForComponentReturnsNativeCodecForUint
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:@((NSUInteger)5)];
    assertThat(codec, instanceOf([ASHNativeObjectCodec class]));
}

- (void)testCodecForObjectReturnsNativeCodecForNumber
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForObject:@((CGFloat)2.7)];
    assertThat(codec, instanceOf([ASHNativeObjectCodec class]));
}

- (void)testCodecForComponentReturnsNativeCodecForNumber
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:@((CGFloat)2.7)];
    assertThat(codec, instanceOf([ASHNativeObjectCodec class]));
}

- (void)testCodecForObjectReturnsNativeCodecForString
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForObject:@"Test"];
    assertThat(codec, instanceOf([ASHNativeObjectCodec class]));
}

- (void)testCodecForComponentReturnsNativeCodecForString
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:@"Test"];
    assertThat(codec, instanceOf([ASHNativeObjectCodec class]));
}

- (void)testCodecForObjectReturnsNativeCodecForBoolean
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForObject:@(YES)];
    assertThat(codec, instanceOf([ASHNativeObjectCodec class]));
}

- (void)testCodecForComponentReturnsNativeCodecForBoolean
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:@(YES)];
    assertThat(codec, instanceOf([ASHNativeObjectCodec class]));
}

- (void)testCodecForObjectReturnsClassCodecForClass
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForObject:[MockPoint class]];
    assertThat(codec, instanceOf([ASHClassObjectCodec class]));
}

- (void)testCodecForComponentReturnsClassCodecForClass
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:[MockPoint class]];
    assertThat(codec, instanceOf([ASHClassObjectCodec class]));
}

- (void)testCodecForObjectReturnsClassCodecForArray
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForObject:@[]];
    assertThat(codec, instanceOf([ASHArrayObjectCodec class]));
}

- (void)testCodecForComponentReturnsClassCodecForArray
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:@[]];
    assertThat(codec, instanceOf([ASHArrayObjectCodec class]));
}

- (void)testCodecForObjectReturnsClassCodecForMutableArray
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForObject:@[].mutableCopy];
    assertThat(codec, instanceOf([ASHArrayObjectCodec class]));
}

- (void)testCodecForComponentReturnsClassCodecForMutableArray
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:@[].mutableCopy];
    assertThat(codec, instanceOf([ASHArrayObjectCodec class]));
}

- (void)testCodecForObjectReturnsClassCodecForValue
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForObject:[NSValue valueWithCGPoint:CGPointMake(1, 2)]];
    assertThat(codec, instanceOf([ASHValueObjectCodec class]));
}

- (void)testCodecForComponentReturnsClassCodecForValue
{
    id <ASHObjectCodec> codec = [_codecManager getCodecForComponent:[NSValue valueWithCGPoint:CGPointMake(1, 2)]];
    assertThat(codec, instanceOf([ASHValueObjectCodec class]));
}





@end