
#import "MockHelpers.h"
#define HC_SHORTHAND
#import <objc/message.h>

@class SystemTests;

@interface MockSystem0 : ASHSystem

@property (nonatomic, strong) SystemTests * tests;

- (id)initWithSystemTests:(SystemTests *)tests;

@end


@interface SystemTests : GHAsyncTestCase

@property (nonatomic, strong) ASHEngine * engine;

@property (nonatomic, strong) MockSystem0 * system1;
@property (nonatomic, strong) MockSystem0 * system2;

@property (nonatomic, assign) SEL asyncCallback;
@property (nonatomic, weak) id asyncTarget;

@end

@implementation SystemTests
@synthesize engine;

- (void)setUp
{
    [self createEngine];
}

- (void)tearDown
{
    [self clearEngine];
}

- (void)createEngine
{
    self.engine = [[ASHEngine alloc] init];
}

- (void)clearEngine
{
    self.engine = nil;
    self.asyncCallback = nil;
    self.asyncTarget = nil;
}

- (void)testSystemsGetterReturnsAllTheSystems
{
    ASHSystem * system1 = [[ASHSystem alloc] init];
    [engine addSystem:system1
             priority:1];
    ASHSystem * system2 = [[ASHSystem alloc] init];
    [engine addSystem:system2
             priority:1];
    assertThatUnsignedInteger(engine.allSystems.count, equalToUnsignedInteger(2));
    assertThat(engine.allSystems, hasItems(system1, system2, nil));
}

- (void)testAddSystemCallsAddToEngine
{
    ASHSystem * system = [[MockSystem0 alloc] initWithSystemTests:self];
    self.asyncCallback = @selector(addedCallbackMethod:action:systemEngine:);
    self.asyncTarget = self;
    [engine addSystem:system
             priority:0];
}

- (void)testRemoveSystemCallsRemovedFromEngine
{
    ASHSystem * system = [[MockSystem0 alloc] initWithSystemTests:self];
    [engine addSystem:system
             priority:0];
    self.asyncCallback = @selector(removedCallbackMethod:action:systemEngine:);
    self.asyncTarget = self;
    [engine removeSystem:system];
}

- (void)testEngineCallsUpdateOnSystems
{
    ASHSystem * system = [[MockSystem0 alloc] initWithSystemTests:self];
    [engine addSystem:system
             priority:0];
    self.asyncCallback = @selector(updateCallbackMethod:action:time:);
    self.asyncTarget = self;
    [system update:0.1];
}

- (void)testDefaultPriorityIsZero
{
    ASHSystem * system = [[MockSystem0 alloc] initWithSystemTests:self];
    assertThatInteger(system.priority, equalToInteger(0));
}

- (void)testCanSetPriorityWhenAddingSystem
{
    ASHSystem * system = [[MockSystem0 alloc] initWithSystemTests:self];
    [engine addSystem:system
             priority:10];
    assertThatInteger(system.priority, equalToInteger(10));
}

- (void)testSystemsUpdatedInPriorityOrderIfSameAsAddOrder
{
    self.system1 = [[MockSystem0 alloc] initWithSystemTests:self];
    [engine addSystem:_system1
             priority:10];
    self.system2 = [[MockSystem0 alloc] initWithSystemTests:self];
    [engine addSystem:_system2
             priority:20];
    self.asyncTarget = self;
    self.asyncCallback = @selector(updateCallbackMethod1:action:time:);
    [engine update:0.1];
    
}

- (void)testSystemsUpdatedInPriorityOrderIfPrioritiesAreNegative
{
    self.system2 = [[MockSystem0 alloc] initWithSystemTests:self];
    [engine addSystem:_system2
             priority:10];
    self.system1 = [[MockSystem0 alloc] initWithSystemTests:self];
    [engine addSystem:_system1
             priority:-20];
    self.asyncTarget = self;
    self.asyncCallback = @selector(updateCallbackMethod1:action:time:);
    [engine update:0.1];
}

- (void)testUpdatingIsFalseBeforeUpdate
{
    assertThatBool(engine.updating, equalToBool(NO));
}

- (void)testUpdatingIsTrueDuringUpdate
{
    ASHSystem * system = [[MockSystem0 alloc] initWithSystemTests:self];
    [engine addSystem:system
             priority:0];
    self.asyncTarget = self;
    self.asyncCallback = @selector(assertsUpdatingIsTrue:action:time:);
    [engine update:0.1];
    
}

- (void)testUpdatingIsFalseAfterUpdate
{
    [engine update:0.1];
    assertThatBool(engine.updating, equalToBool(NO));
}

- (void)testCompleteSignalIsDispatchedAfterUpdate
{
    [super prepare];

    ASHSystem * system = [[MockSystem0 alloc] initWithSystemTests:self];
    [engine addSystem:system
             priority:0];
    self.asyncCallback = @selector(listensForUpdateComplete:action:time:);
    self.asyncTarget = self;
    
    [engine update:0.1];
    
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)testGetSystemReturnsTheSystem
{
    ASHSystem * system1 = [[MockSystem0 alloc] initWithSystemTests:self];
    [engine addSystem:system1
             priority:0];
    [engine addSystem:[[ASHSystem alloc] init]
             priority:0];
    assertThat([engine getSystem:[MockSystem0 class]], sameInstance(system1));
}

- (void)testGetSystemReturnsNullIfNoSuchSystem
{
    [engine addSystem:[[ASHSystem alloc] init]
             priority:0];
    assertThat([engine getSystem:[MockSystem0 class]], nilValue());
}

- (void)testRemoveAllSystemsDoesWhatItSays
{
    [engine addSystem:[[ASHSystem alloc] init] priority:0];
    [engine addSystem:[[MockSystem0 alloc] initWithSystemTests:self]
             priority:0];
    [engine removeAllSystems];
    assertThat([engine getSystem:[MockSystem0 class]], nilValue());
    assertThat([engine getSystem:[ASHSystem class]], nilValue());
}

- (void)testRemoveAllSystemsSetsNextToNull
{
    ASHSystem * system1 = [[ASHSystem alloc] init];
    [engine addSystem:system1 priority:1];
    ASHSystem * system2 = [[ASHSystem alloc] init];
    [engine addSystem:system2 priority:2];
    assertThat(system1->next, sameInstance(system2));
    [engine removeAllSystems];
    assertThat(system1->next, nilValue());
}

- (void)testRemoveSystemAndAddItAgainDontCauseInvalidLinkedList
{
    ASHSystem * systemB = [[ASHSystem alloc] init];
    ASHSystem * systemC = [[ASHSystem alloc] init];
    [engine addSystem:systemB
             priority:0];
    [engine addSystem:systemC
             priority:0];
    [engine removeSystem:systemB];
    [engine addSystem:systemB
             priority:0];
    assertThat(systemC->previous, nilValue());
    assertThat(systemB->next, nilValue());
}

- (void)addedCallbackMethod:(ASHSystem *)system
                     action:(NSString *)action
               systemEngine:(ASHEngine *)systemEngine
{
    assertThat(action, equalTo(@"added"));
    assertThat(systemEngine, sameInstance(engine));
}

- (void)removedCallbackMethod:(ASHSystem *)system
                       action:(NSString *)action
                 systemEngine:(ASHEngine *)systemEngine
{
    assertThat(action, equalTo(@"removed"));
    assertThat(systemEngine, sameInstance(engine));
}

- (void)updateCallbackMethod:(ASHSystem *)system
                      action:(NSString *)action
                        time:(NSNumber *)time
{
    assertThat(action, equalTo(@"update"));
    assertThat(time, equalTo(@(0.1)));
}

- (void)updateCallbackMethod1:(ASHSystem *)system
                       action:(NSString *)action
                         time:(NSNumber *)time
{
    assertThat(system, equalTo(_system1));
    self.asyncCallback = @selector(updateCallbackMethod2:action:time:);
}

- (void)updateCallbackMethod2:(ASHSystem *)system
                       action:(NSString *)action
                         time:(NSNumber *)time
{
    assertThat(system, equalTo(_system2));
}

- (void)assertsUpdatingIsTrue:(ASHSystem *)system
                       action:(NSString *)action
                         time:(NSNumber *)time
{
    assertThatBool(engine.updating, equalToBool(YES));
}

- (void)listensForUpdateComplete:(ASHSystem *)system
                          action:(NSString *)action
                            time:(NSNumber *)time
{
    [engine.updateComplete addListener:self
                                action:@selector(callbackListensForUpdateComplete)];

}

- (void)callbackListensForUpdateComplete
{
    [super notify:kGHUnitWaitStatusSuccess
      forSelector:@selector(testCompleteSignalIsDispatchedAfterUpdate)];
}

@end

@implementation MockSystem0
@synthesize tests = tests;

- (id)initWithSystemTests:(SystemTests *)systemTests
{
    self = [super init];
    
    if (self != nil)
    {
        self.tests = systemTests;
    }
    
    return self;
}

- (void)addToEngine:(ASHEngine *)engine
{
    if(tests.asyncCallback != nil && tests.asyncTarget != nil)
    {
        ((void(*)(id, SEL, id, id, id))objc_msgSend)(tests.asyncTarget, tests.asyncCallback, self, @"added", engine);
    }
}

- (void)removeFromEngine:(ASHEngine *)engine
{
    if(tests.asyncCallback != nil && tests.asyncTarget != nil)
    {
        ((void(*)(id, SEL, id, id, id))objc_msgSend)(tests.asyncTarget, tests.asyncCallback, self, @"removed", engine);
    }
}

- (void)update:(double)time
{
    if(tests.asyncCallback != nil && tests.asyncTarget != nil)
    {
        ((void(*)(id, SEL, id, id, id))objc_msgSend)(tests.asyncTarget, tests.asyncCallback, self, @"update", @(time));
    }
}

@end

