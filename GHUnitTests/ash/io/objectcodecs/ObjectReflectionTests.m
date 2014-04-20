
#import "MockReflectionObject.h"
#import "ASHObjectReflection.h"
#import "ASHObjectReflectionFactory.h"
#import "MockPoint.h"

@interface ObjectReflectionTests : GHTestCase
@end

@implementation ObjectReflectionTests
{
    MockReflectionObject * _object;
    ASHObjectReflection * _reflection;
}

- (void)createReflection
{
    _object = [[MockReflectionObject alloc] init];
    _reflection = [[ASHObjectReflection alloc] initWithComponent:_object];
}

- (void)clearReflection
{
    _object = nil;
    _reflection = nil;
}

- (void)setUp
{
    [self createReflection];
}

- (void)tearDown
{
    [self clearReflection];
}

- (void)testReflectionReturnsCorrectType
{
    assertThat(_reflection.type, equalTo(NSStringFromClass([MockReflectionObject class])));
}

- (void)testReflectionReturnsIntVariable
{
    assertThat(_reflection.propertyTypes[@"intVariable"], equalTo(NSStringFromClass([NSNumber class])));
}

- (void)testReflectionReturnsUintVariable
{
    assertThat(_reflection.propertyTypes[@"uintVariable"], equalTo(NSStringFromClass([NSNumber class])));
}

- (void)testReflectionReturnsNumberVariable
{
    assertThat(_reflection.propertyTypes[@"numberVariable"], equalTo(NSStringFromClass([NSNumber class])));
}

- (void)testReflectionReturnsBooleanVariable
{
    assertThat(_reflection.propertyTypes[@"booleanVariable"], equalTo(NSStringFromClass([NSNumber class])));
}

- (void)testReflectionReturnsStringVariable
{
    assertThat(_reflection.propertyTypes[@"stringVariable"], equalTo(NSStringFromClass([NSString class])));
}

- (void)testReflectionReturnsObjectVariable
{
    assertThat(_reflection.propertyTypes[@"pointVariable"], equalTo(NSStringFromClass([MockPoint class])));
}

- (void)testReflectionReturnsFullAccessor
{
    assertThat(_reflection.propertyTypes[@"fullAccessor"], equalTo(NSStringFromClass([NSNumber class])));
}

- (void)testReflectionDoesntReturnGetOnlyAccessor
{
    assertThat(_reflection.propertyTypes[@"getOnlyAccessor"], equalTo(nil));
}

- (void)testReflectionDoesntReturnSetOnlyAccessor
{
    assertThat(_reflection.propertyTypes[@"setOnlyAccessor"], equalTo(nil));
}

- (void)testFactoryCachesReflection
{
    MockReflectionObject * object1 = [[MockReflectionObject alloc] init];
    ASHObjectReflection * reflection1 = [[ASHObjectReflectionFactory sharedFactory] reflection:object1];
    MockReflectionObject * object2 = [[MockReflectionObject alloc] init];
    ASHObjectReflection * reflection2 = [[ASHObjectReflectionFactory sharedFactory] reflection:object2];
    assertThat(reflection2, sameInstance(reflection1));
}







@end