
#import "ASHEngineStateMachine.h"
#import "ASHEngine.h"
#import "ASHEngineState.h"
#import "MockHelpers.h"

@interface EngineStateMachineTests : GHTestCase

@property (nonatomic, strong) ASHEngineStateMachine * fsm;
@property (nonatomic, strong) ASHEngine * engine;

@end

@implementation EngineStateMachineTests
{

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
    self.engine = [[ASHEngine alloc] init];
    self.fsm = [[ASHEngineStateMachine alloc] initWithEngine:self.engine];
}

- (void)clearState
{
    self.engine = nil;
    self.fsm = nil;
}

- (void)testEnterStateAddsStatesSystems
{
    ASHEngineState * state = [[ASHEngineState alloc] init];
    MockSystem * system = [[MockSystem alloc] init];
    [state addInstance:system];
    [self.fsm addState:@"test"
                 state:state];
    [self.fsm changeState:@"test"];
    assertThat([self.engine getSystem:[MockSystem class]], sameInstance(system));
}

- (void)testEnterSecondStateAddsSecondStatesSystems
{
    ASHEngineState * state1 = [[ASHEngineState alloc] init];
    MockSystem * system1 = [[MockSystem alloc] init];
    [state1 addInstance:system1];
    [self.fsm addState:@"test1"
                 state:state1];
    [self.fsm changeState:@"test1"];

    ASHEngineState * state2 = [[ASHEngineState alloc] init];
    MockSystem2 * system2 = [[MockSystem2 alloc] init];
    [state2 addInstance:system2];
    [self.fsm addState:@"test2"
                 state:state2];
    [self.fsm changeState:@"test2"];

    assertThat([self.engine getSystem:[MockSystem2 class]], sameInstance(system2));
}

- (void)testEnterSecondStateRemovesFirstStatesSystems
{
    ASHEngineState * state1 = [[ASHEngineState alloc] init];
    MockSystem * system1 = [[MockSystem alloc] init];
    [state1 addInstance:system1];
    [self.fsm addState:@"test1"
                 state:state1];
    [self.fsm changeState:@"test1"];

    ASHEngineState * state2 = [[ASHEngineState alloc] init];
    MockSystem2 * system2 = [[MockSystem2 alloc] init];
    [state2 addInstance:system2];
    [self.fsm addState:@"test2"
                 state:state2];
    [self.fsm changeState:@"test2"];

    assertThat([self.engine getSystem:[MockSystem class]], nilValue());
}

- (void)testEnterSecondStateDoesNotRemoveOverlappingSystems
{
    ASHEngineState * state1 = [[ASHEngineState alloc] init];
    MockSystem * system1 = [[MockSystem alloc] init];
    [state1 addInstance:system1];
    [self.fsm addState:@"test1"
                 state:state1];
    [self.fsm changeState:@"test1"];

    ASHEngineState * state2 = [[ASHEngineState alloc] init];
    MockSystem2 * system2 = [[MockSystem2 alloc] init];
    [state2 addInstance:system1];
    [state2 addInstance:system2];
    [self.fsm addState:@"test2"
                 state:state2];
    [self.fsm changeState:@"test2"];
    assertThatBool(system1.wasRemoved, isFalse());
    assertThat([self.engine getSystem:[MockSystem class]], sameInstance(system1));
}

- (void)testEnterSecondStateRemovesDifferentSystemsOfSameType
{
    ASHEngineState * state1 = [[ASHEngineState alloc] init];
    MockSystem * system1 = [[MockSystem alloc] init];
    [state1 addInstance:system1];
    [self.fsm addState:@"test1"
                 state:state1];

    ASHEngineState * state2 = [[ASHEngineState alloc] init];
    MockSystem * system3 = [[MockSystem alloc] init];
    MockSystem2 * system2 = [[MockSystem2 alloc] init];
    [state2 addInstance:system3];
    [state2 addInstance:system2];
    [self.fsm addState:@"test2"
                 state:state2];
    [self.fsm changeState:@"test2"];
    assertThat([self.engine getSystem:[MockSystem class]], sameInstance(system3));
}

@end