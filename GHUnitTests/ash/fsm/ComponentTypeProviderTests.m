
#import "MockHelpers.h"
#import "ASHComponentTypeProvider.h"

@interface ComponentTypeProviderTests : GHTestCase

@end


@implementation ComponentTypeProviderTests

- (void)testProviderReturnsAnInstanceOfType
{
    ASHComponentTypeProvider * provider = [[ASHComponentTypeProvider alloc] initWithType:[MockComponent class]];
    assertThat([provider getComponent], instanceOf([MockComponent class]));
}

- (void)testProviderReturnsNewInstanceEachTime
{
    ASHComponentTypeProvider * provider = [[ASHComponentTypeProvider alloc] initWithType:[MockComponent class]];
    assertThat([provider getComponent], isNot([provider getComponent]));
}

- (void)testProvidersWithSameTypeHaveSameIdentifier
{
    ASHComponentTypeProvider * provider1 = [[ASHComponentTypeProvider alloc] initWithType:[MockComponent class]];
    ASHComponentTypeProvider * provider2 = [[ASHComponentTypeProvider alloc] initWithType:[MockComponent class]];
    assertThat(provider1.identifier, equalTo(provider2.identifier));
}

- (void)testProvidersWithDifferentTypeHaveDifferentIdentifier
{
    ASHComponentTypeProvider * provider1 = [[ASHComponentTypeProvider alloc] initWithType:[MockComponent class]];
    ASHComponentTypeProvider * provider2 = [[ASHComponentTypeProvider alloc] initWithType:[MockComponent2 class]];
    assertThat(provider1.identifier, isNot(provider2.identifier));
}

@end
