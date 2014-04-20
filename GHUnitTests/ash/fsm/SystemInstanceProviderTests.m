
#import "ASHEngine.h"
#import "MockHelpers.h"
#import "ASHSystemInstanceProvider.h"

@interface SystemInstanceProviderTests : GHTestCase

@end

@implementation SystemInstanceProviderTests
{

}

- (void)testProviderReturnsTheInstance
{
    MockSystem * instance = [[MockSystem alloc] init];
    ASHSystemInstanceProvider * provider = [[ASHSystemInstanceProvider alloc] initWithInstance:instance];
    assertThat(provider.getSystem, sameInstance(instance));
}

- (void)testProvidersWithSameInstanceHaveSameIdentifier
{
    MockSystem * instance = [[MockSystem alloc] init];
    ASHSystemInstanceProvider * provider1 = [[ASHSystemInstanceProvider alloc] initWithInstance:instance];
    ASHSystemInstanceProvider * provider2 = [[ASHSystemInstanceProvider alloc] initWithInstance:instance];
    assertThat(provider1.identifier, equalTo(provider2.identifier));
}

- (void)testProvidersWithDifferentInstanceHaveDifferentIdentifier
{
    ASHSystemInstanceProvider * provider1 = [[ASHSystemInstanceProvider alloc] initWithInstance:[[MockSystem alloc] init]];
    ASHSystemInstanceProvider * provider2 = [[ASHSystemInstanceProvider alloc] initWithInstance:[[MockSystem alloc] init]];
    assertThat(provider1.identifier, isNot(equalTo(provider2.identifier)));
}


@end