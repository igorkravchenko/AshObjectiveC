
#import <GHUnitIOS/GHUnit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "MockHelpers.h"
#import "ASHComponentSingletonProvider.h"

@interface ComponentSingletonProviderTests : GHTestCase

@end


@implementation ComponentSingletonProviderTests

- (void)testProviderReturnsAnInstanceOfType
{
    ASHComponentSingletonProvider * provider = [[ASHComponentSingletonProvider alloc] initWithType:[MockComponent class]];
    assertThat([provider getComponent], instanceOf([MockComponent class]));
}

- (void)testProviderReturnsSameInstanceEachTime
{
    ASHComponentSingletonProvider * provider = [[ASHComponentSingletonProvider alloc] initWithType:[MockComponent class]];
    assertThat([provider getComponent], equalTo([provider getComponent]));
}

- (void)testProvidersWithSameTypeHaveDifferentIdentifier
{
    ASHComponentSingletonProvider * provider1 = [[ASHComponentSingletonProvider alloc] initWithType:[MockComponent class]];
    ASHComponentSingletonProvider * provider2 = [[ASHComponentSingletonProvider alloc] initWithType:[MockComponent class]];
    assertThat(provider1.identifier, isNot(provider2.identifier));
}

- (void)testProvidersWithDifferentTypeHaveDifferentIdentifier
{
    ASHComponentSingletonProvider * provider1 = [[ASHComponentSingletonProvider alloc] initWithType:[MockComponent class]];
    ASHComponentSingletonProvider * provider2 = [[ASHComponentSingletonProvider alloc] initWithType:[MockComponent2 class]];
    assertThat(provider1.identifier, isNot(provider2.identifier));
}

@end
