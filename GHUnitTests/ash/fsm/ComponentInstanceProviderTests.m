
#import <GHUnitIOS/GHUnit.h>
#import "MockHelpers.h"
#import "ASHComponentInstanceProvider.h"

@interface ComponentInstanceProviderTests : GHTestCase

@end


@implementation ComponentInstanceProviderTests

- (void)testProviderReturnsTheInstance
{
    MockComponent * instance = [[MockComponent alloc] init];
    ASHComponentInstanceProvider * provider = [[ASHComponentInstanceProvider alloc] initWithInstance:instance];
    assertThat([provider getComponent], sameInstance(instance));
}

- (void)testProvidersWithSameInstanceHaveSameIdentifier
{
    MockComponent * instance = [[MockComponent alloc] init];
    ASHComponentInstanceProvider * provider1 = [[ASHComponentInstanceProvider alloc] initWithInstance:instance];
    ASHComponentInstanceProvider * provider2 = [[ASHComponentInstanceProvider alloc] initWithInstance:instance];
    assertThat(provider1.identifier, equalTo(provider2.identifier));
}

- (void)testProvidersWithDifferentInstanceHaveDifferentIdentifier
{
    ASHComponentInstanceProvider * provider1 = [[ASHComponentInstanceProvider alloc] initWithInstance:[[MockComponent alloc] init]];
    ASHComponentInstanceProvider * provider2 = [[ASHComponentInstanceProvider alloc] initWithInstance:[[MockComponent alloc] init]];
    assertThat(provider1.identifier, isNot(provider2.identifier));
}

@end
