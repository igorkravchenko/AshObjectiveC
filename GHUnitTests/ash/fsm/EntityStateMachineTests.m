
#import "MockHelpers.h"
#import "ASHEntityStateMachine.h"
#import "ASHStateComponentMapping.h"

@interface EntityStateMachineTests : GHAsyncTestCase

@property (nonatomic, retain) ASHEntityStateMachine * fsm;
@property (nonatomic, retain) ASHEntity * entity;

@end


@implementation EntityStateMachineTests
@synthesize entity;
@synthesize fsm;

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
    self.entity = [[ASHEntity alloc] init];
    self.fsm = [[ASHEntityStateMachine alloc] initWithEntity:entity];
}

- (void)clearState
{
    self.entity = nil;
    self.fsm = nil;
}

- (void)testEnterStateAddsStatesComponents
{
    ASHEntityState * state = [[ASHEntityState alloc] init];
    MockComponent * component = [[MockComponent alloc] init];
    [[state add:[MockComponent class]] withInstance:component];
    [fsm addState:@"test"
            state:state];
    [fsm changeState:@"test"];
    assertThat([entity getComponent:[MockComponent class]], sameInstance(component));
}

- (void)testEnterSecondStateAddsSecondStatesComponents
{
    ASHEntityState * state1 = [[ASHEntityState alloc] init];
    MockComponent * component1 = [[MockComponent alloc] init];
    [[state1 add:[MockComponent class]] withInstance:component1];
    [fsm addState:@"test1"
            state:state1];
    [fsm changeState:@"test1"];
    
    ASHEntityState * state2 = [[ASHEntityState alloc] init];
    MockComponent2 * component2 = [[MockComponent2 alloc] init];
    [[state2 add:[MockComponent2 class]] withInstance:component2];
    [fsm addState:@"test2"
            state:state2];
    [fsm changeState:@"test2"];
    assertThat([entity getComponent:[MockComponent2 class]], sameInstance(component2));
}

- (void)testEnterSecondStateRemovesFirstStatesComponents
{
    ASHEntityState * state1 = [[ASHEntityState alloc] init];
    MockComponent * component1 = [[MockComponent alloc] init];
    [[state1 add:[MockComponent class]] withInstance:component1];
    [fsm addState:@"test1"
            state:state1];
    
    ASHEntityState * state2 = [[ASHEntityState alloc] init];
    MockComponent2 * component2 = [[MockComponent2 alloc] init];
    [[state2 add:[MockComponent2 class]] withInstance:component2];
    [fsm addState:@"test2"
            state:state2];
    [fsm changeState:@"test2"];
    assertThatBool([entity hasComponent:[MockComponent class]], isFalse());
}

- (void)testEnterSecondStateDoesNotRemoveOverlappingComponents
{
    [entity.componentRemoved addListener:self
                                  action:@selector(failIfCalled)];
    ASHEntityState * state1 = [[ASHEntityState alloc] init];
    MockComponent * component1 = [[MockComponent alloc] init];
    [[state1 add:[MockComponent class]] withInstance:component1];
    [fsm addState:@"test1"
            state:state1];
    [fsm changeState:@"test1"];

    ASHEntityState * state2 = [[ASHEntityState alloc] init];
    MockComponent2 * component2 = [[MockComponent2 alloc] init];
    [[state2 add:[MockComponent class]] withInstance:component1];
    [[state2 add:[MockComponent2 class]] withInstance:component2];
    [fsm addState:@"test2"
            state:state2];
    [fsm changeState:@"test2"];
    assertThat([entity getComponent:[MockComponent class]], sameInstance(component1));
}

- (void)testEnterSecondStateRemovesDifferentComponentsOfSameType
{
    ASHEntityState * state1 = [[ASHEntityState alloc] init];
    MockComponent * component1 = [[MockComponent alloc] init];
    [[state1 add:[MockComponent class]] withInstance:component1];
    [fsm addState:@"test1"
            state:state1];
    [fsm changeState:@"test1"];

    ASHEntityState * state2 = [[ASHEntityState alloc] init];
    MockComponent * component3 = [[MockComponent alloc] init];
    MockComponent2 * component2 = [[MockComponent2 alloc] init];
    [[state2 add:[MockComponent class]] withInstance:component3];
    [[state2 add:[MockComponent2 class]] withInstance:component2];
    [fsm addState:@"test2"
            state:state2];
    [fsm changeState:@"test2"];
    assertThat([entity getComponent:[MockComponent class]], sameInstance(component3));
}

- (void)failIfCalled
{
    [super failWithException:[NSException exceptionWithName:@"Failure"
                                                     reason:@"Component was removed when it shouldn't have been."
                                                   userInfo:nil]];
}

@end
