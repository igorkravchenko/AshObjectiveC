
#define HC_SHORTHAND
#import "ASHSystem.h"
#import "ASHSystemSingletonProvider.h"
#import "MockHelpers.h"

@interface SystemSingletonProviderTests : GHTestCase

@end

@implementation SystemSingletonProviderTests
{

}

- (void)testProviderReturnsAnInstanceOfSystem
{
    ASHSystemSingletonProvider * provider = [[ASHSystemSingletonProvider alloc] initWithComponentType:[MockSystem class]];
    assertThat(provider.getSystem, instanceOf([MockSystem class]));
}

- (void)testProviderReturnsSameInstanceEachTime
{
    ASHSystemSingletonProvider * provider = [[ASHSystemSingletonProvider alloc] initWithComponentType:[MockSystem class]];
    assertThat(provider.getSystem, equalTo(provider.getSystem));
}

- (void)testProvidersWithSameSystemHaveDifferentIdentifier
{
    ASHSystemSingletonProvider * provider1 = [[ASHSystemSingletonProvider alloc] initWithComponentType:[MockSystem class]];
    ASHSystemSingletonProvider * provider2 = [[ASHSystemSingletonProvider alloc] initWithComponentType:[MockSystem class]];
    assertThat(provider1.identifier, isNot(provider2.identifier));
}

- (void)testProvidersWithDifferentSystemsHaveDifferentIdentifier
{
    ASHSystemSingletonProvider * provider1 = [[ASHSystemSingletonProvider alloc] initWithComponentType:[MockSystem class]];
    ASHSystemSingletonProvider * provider2 = [[ASHSystemSingletonProvider alloc] initWithComponentType:[MockSystem2 class]];
    assertThat(provider1.identifier, isNot(provider2.identifier));
}

@end