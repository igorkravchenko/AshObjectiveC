
#import "ASHEngineState.h"
#import "MockHelpers.h"
#import "ASHSystemProvider.h"
#import "ASHSystemInstanceProvider.h"
#import "ASHDynamicSystemProvider.h"
#import "ASHStateSystemMapping.h"

@interface SystemStateTests : GHTestCase
@end

@implementation SystemStateTests
{
    ASHEngineState * _state;
    ASHSystem * _system;
}

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
    _state = [[ASHEngineState alloc] init];
}

- (void)clearState
{
    _state = nil;
}

- (void)testAddInstanceCreatesInstanceProvider
{
    MockSystem * component = [[MockSystem alloc] init];
    [_state addInstance:component];
    id <ASHSystemProvider> provider = _state.providers.firstObject;
    assertThat(provider, instanceOf([ASHSystemInstanceProvider class]));
    assertThat(provider.getSystem, equalTo(component));
}

- (void)testAddSingletonCreatesSingletonProvider
{
    [_state addSingleton:[MockSystem class]];
    id <ASHSystemProvider> provider = _state.providers.firstObject;
    assertThat(provider.getSystem, instanceOf([MockSystem class]));
}

- (void)testAddMethodCreatesMethodProvider
{
    ASHSystem * const instance = [[MockSystem alloc] init];
    _system = instance;
    SEL const methodProvider = @selector(methodProvider);
    [_state addMethod:self
               action:methodProvider];

    id <ASHSystemProvider> provider = _state.providers.firstObject;
    assertThat(provider, instanceOf([ASHDynamicSystemProvider class]));
    assertThat(provider.getSystem, instanceOf([MockSystem class]));
}

- (void)testWithPrioritySetsPriorityOnProvider
{
    NSInteger priority = 10;
    [[_state addSingleton:[MockSystem class]] withPriority:priority];
    id <ASHSystemProvider> provider = _state.providers.firstObject;
    assertThatInteger(provider.priority, equalToInteger(provider.priority));
}

- (ASHSystem *)methodProvider
{
    return _system;
}








@end