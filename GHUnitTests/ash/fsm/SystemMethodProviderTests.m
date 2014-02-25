
#import <GHUnitIOS/GHTestCase.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "MockHelpers.h"
#import "ASHDynamicSystemProvider.h"

@interface SystemMethodProviderTests : GHTestCase

@end

@implementation SystemMethodProviderTests
{
    MockSystem * _system;
}

- (void)testProviderReturnsTheInstance
{
    MockSystem * instance = [[MockSystem alloc] init];
    _system = instance;
    ASHDynamicSystemProvider * provider = [[ASHDynamicSystemProvider alloc] initWithTarget:self
                                                                                    method:@selector(providerMethod)];
    assertThat(provider.getSystem, sameInstance(instance));
}

- (ASHSystem *)providerMethod
{
    return  _system;
}

- (ASHSystem *)providerMethod2
{
    return  _system;
}

- (void)testProvidersWithSameMethodHaveSameIdentifier
{
    MockSystem * instance = [[MockSystem alloc] init];
    _system = instance;
    SEL providerMethod = @selector(providerMethod);
    ASHDynamicSystemProvider * provider1 = [[ASHDynamicSystemProvider alloc] initWithTarget:self
                                                                                     method:providerMethod];
    ASHDynamicSystemProvider * provider2 = [[ASHDynamicSystemProvider alloc] initWithTarget:self
                                                                                     method:providerMethod];
    assertThat(provider1.identifier, equalTo(provider2.identifier));
}

- (void)testProvidersWithDifferentMethodHaveDifferentIdentifier
{
    MockSystem * instance = [[MockSystem alloc] init];
    _system = instance;
    SEL providerMethod1 = @selector(providerMethod);
    SEL providerMethod2 = @selector(providerMethod2);
    ASHDynamicSystemProvider * provider1 = [[ASHDynamicSystemProvider alloc] initWithTarget:self
                                                                                     method:providerMethod1];
    ASHDynamicSystemProvider * provider2 = [[ASHDynamicSystemProvider alloc] initWithTarget:self
                                                                                     method:providerMethod2];
    assertThat(provider1.identifier, isNot(provider2.identifier));
}


@end