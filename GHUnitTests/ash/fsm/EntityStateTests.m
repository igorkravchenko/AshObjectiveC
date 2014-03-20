
#import <GHUnitIOS/GHUnit.h>
#import "ASHEntityState.h"
#import "MockHelpers.h"
#import "ASHComponentTypeProvider.h"
#import "ASHStateComponentMapping.h"
#import "ASHComponentSingletonProvider.h"
#import "ASHDynamicComponentProvider.h"

@interface EntityStateTests : GHAsyncTestCase

@property (nonatomic, strong) ASHEntityState * state;

@end


@implementation EntityStateTests
@synthesize state;

- (void)setUp
{
    [self createState];
}

- (void)tearDown
{
    [self clearState];
}

- (void)createState
{
    self.state = [[ASHEntityState alloc] init];
}

- (void)clearState
{
    self.state = nil;
}

- (void)testAddWithNoQualifierCreatesTypeProvider
{
    [state add:[MockComponent class]];
    id <ASHComponentProvider> provider = state.providers[NSStringFromClass([MockComponent class])];
    assertThat(provider, instanceOf([ASHComponentTypeProvider class]));
    assertThat([provider getComponent], instanceOf([MockComponent class]));
}

- (void)testAddWithTypeQualifierCreatesTypeProvider
{
    [[state add:[MockComponent class]] withType:[MockComponent2 class]];
    id <ASHComponentProvider> provider = state.providers[NSStringFromClass([MockComponent class])];
    assertThat(provider, instanceOf([ASHComponentTypeProvider class]));
    assertThat([provider getComponent], instanceOf([MockComponent2 class]));
}

- (void)testAddWithInstanceQualifierCreatesInstanceProvider
{
    MockComponent * component = [[MockComponent alloc] init];
    [[state add:[MockComponent class]] withInstance:component];
    id <ASHComponentProvider> provider = state.providers[NSStringFromClass([MockComponent class])];
    assertThat(provider, instanceOf([ASHComponentInstanceProvider class]));
    assertThat([provider getComponent], equalTo(component));
}

- (void)testAddWithSingletonQualifierCreatesSingletonProvider
{
    [[state add:[MockComponent class]] withSingletonForType:[MockComponent class]];
    id <ASHComponentProvider> provider = state.providers[NSStringFromClass([MockComponent class])];
    assertThat(provider, instanceOf([ASHComponentSingletonProvider class]));
    assertThat([provider getComponent], instanceOf([MockComponent class]));
}

- (void)testAddWithMethodQualifierCreatesDynamicProvider
{
    [[state add:[MockComponent class]] withTarget:self
                                           method:@selector(dynamicProviderMethod)];
    id <ASHComponentProvider> provider = state.providers[NSStringFromClass([MockComponent class])];
    assertThat(provider, instanceOf([ASHDynamicComponentProvider class]));
    assertThat([provider getComponent], instanceOf([MockComponent class]));
}

- (id)dynamicProviderMethod
{
    return [[MockComponent alloc] init];
}

@end
