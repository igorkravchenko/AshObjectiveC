
#import <GHUnitIOS/GHUnit.h>
#import "MockHelpers.h"
#import "ASHDynamicComponentProvider.h"

@interface DynamicComponentProviderTests : GHTestCase
@end

@implementation DynamicComponentProviderTests
{
    MockComponent * instance;
}

- (void)setUp
{
    instance = [[MockComponent alloc] init];
}

- (void)tearDown
{
    instance = nil;
}

- (id)instanceProviderMethod
{
    return instance;
}

- (id)instanceProviderMethod2
{
    return instance;
}

- (void)testProviderReturnsTheInstance
{
    id providerTarget = self;
    SEL providerMethod = @selector(instanceProviderMethod);
    ASHDynamicComponentProvider * provider = [[ASHDynamicComponentProvider alloc] initWithTarget:providerTarget
                                                                                         closure:providerMethod];
    assertThat([provider getComponent], sameInstance(instance));
}

- (void)testProvidersWithSameMethodHaveSameIdentifier
{
    id providerTarget = self;
    SEL providerMethod = @selector(instanceProviderMethod);
    ASHDynamicComponentProvider * provider1 = [[ASHDynamicComponentProvider alloc] initWithTarget:providerTarget
                                                                                         closure:providerMethod];
    ASHDynamicComponentProvider * provider2 = [[ASHDynamicComponentProvider alloc] initWithTarget:providerTarget
                                                                                          closure:providerMethod];
    assertThat(provider1.identifier, equalTo(provider2.identifier));
}

- (void)testProvidersWithDifferentMethodsHaveDifferentIdentifier
{
    id providerTarget = self;
    SEL providerMethod1 = @selector(instanceProviderMethod);
    SEL providerMethod2 = @selector(instanceProviderMethod2);
    ASHDynamicComponentProvider * provider1 = [[ASHDynamicComponentProvider alloc] initWithTarget:providerTarget
                                                                                          closure:providerMethod1];
    ASHDynamicComponentProvider * provider2 = [[ASHDynamicComponentProvider alloc] initWithTarget:providerTarget
                                                                                          closure:providerMethod2];
    assertThat(provider1.identifier, isNot(provider2.identifier));
}

@end