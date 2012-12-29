
#import <GHUnitIOS/GHUnit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "ASHSignal0.h"
#import "MockHelpers.h"

@interface SignalTest : GHAsyncTestCase

@property (nonatomic, strong) ASHSignal0 * signal;
@property (nonatomic, assign) SEL currentCall;
@property (nonatomic, assign) BOOL didCallTestAdd2ListenersThenDispatchShouldCallBoth1;
@property (nonatomic, assign) NSUInteger addSameListenerTwiceShouldOnlyAddItOnceCount;

@end


@implementation SignalTest
@synthesize signal;

- (void)setUp
{
    [self createSignal];
}

- (void)tearDown
{
    [self destroySignal];
    self.currentCall = nil;
    self.didCallTestAdd2ListenersThenDispatchShouldCallBoth1 = NO;
}

- (void)createSignal
{
    self.signal = [[ASHSignal0 alloc] init];
}

- (void)destroySignal
{
    self.signal = nil;
}

- (void)testNewSignalHasNoListeners
{
    assertThat(signal.head, nilValue());
}

- (void)testAddListenerThenDispatchShouldCallIt
{
    [super prepare];
    self.currentCall = _cmd;
    [signal addListener:self
                 action:@selector(handleCall)];
    [self dispatchSignal];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)testAddListenerThenRemoveThenDispatchShouldNotCallListener
{
    [signal addListener:self
                 action:@selector(failIfCalled)];
    [signal removeListener:self
                    action:@selector(failIfCalled)];
    [self dispatchSignal];
}

- (void)testRemoveFunctionNotInListenersShouldNotThrowError
{
    [signal removeListener:self
                    action:@selector(handleCall)];
    [signal dispatch];
}

- (void)testAddListenerThenRemoveFunctionNotInListenersShouldStillCallListener
{
    [super prepare];
    self.currentCall = _cmd;
    [signal addListener:self
                 action:@selector(handleCall)];
    [signal removeListener:self
                    action:@selector(failIfCalled)];
    [self dispatchSignal];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)testAdd2ListenersThenDispatchShouldCallBoth
{
    [super prepare];
    [signal addListener:self
                 action:@selector(callbackTestAdd2ListenersThenDispatchShouldCallBoth1)];
    [signal addListener:self
                    action:@selector(callbackTestAdd2ListenersThenDispatchShouldCallBoth2)];
    [self dispatchSignal];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
    
}

- (void)callbackTestAdd2ListenersThenDispatchShouldCallBoth1
{
    self.didCallTestAdd2ListenersThenDispatchShouldCallBoth1 = YES;
}

- (void)callbackTestAdd2ListenersThenDispatchShouldCallBoth2
{
    if (_didCallTestAdd2ListenersThenDispatchShouldCallBoth1)
    {
        [super notify:kGHUnitWaitStatusSuccess
          forSelector:@selector(testAdd2ListenersThenDispatchShouldCallBoth)];
    }
}

- (void)testAdd2ListenersRemove1stThenDispatchShouldCall2ndNot1stListener
{
    [super prepare];
    self.currentCall = _cmd;
    [signal addListener:self
                 action:@selector(failIfCalled)];
    [signal addListener:self
                 action:@selector(handleCall)];
    [signal removeListener:self
                    action:@selector(failIfCalled)];
    [self dispatchSignal];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)testAdd2ListenersRemove2ndThenDispatchShouldCall1stNot2ndListener
{
    [super prepare];
    self.currentCall = _cmd;
    [signal addListener:self
                 action:@selector(handleCall)];
    [signal addListener:self
                 action:@selector(failIfCalled)];
    [signal removeListener:self
                    action:@selector(failIfCalled)];
    [self dispatchSignal];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)testAddSameListenerTwiceShouldOnlyAddItOnce
{
    _addSameListenerTwiceShouldOnlyAddItOnceCount = 0;
    [signal addListener:self
                 action:@selector(callbackAddSameListenerTwiceShouldOnlyAddItOnce)];
    [signal addListener:self
                 action:@selector(callbackAddSameListenerTwiceShouldOnlyAddItOnce)];
    [self dispatchSignal];
    assertThatUnsignedInteger(_addSameListenerTwiceShouldOnlyAddItOnceCount, equalToUnsignedInteger(1));
}

- (void)callbackAddSameListenerTwiceShouldOnlyAddItOnce
{
    ++_addSameListenerTwiceShouldOnlyAddItOnceCount;
}

- (void)testAddTheSameListenerTwiceShouldNotThrowError
{
    [signal addListener:self
                 action:@selector(handleCall)];
    [signal addListener:self
                 action:@selector(handleCall)];
}

- (void)testDispatch2Listeners1stListenerRemovesItselfThen2ndListenerIsStillCalled
{
    [super prepare];
    self.currentCall = _cmd;
    [signal addListener:self
                 action:@selector(selfRemover)];
    [signal addListener:self
                 action:@selector(handleCall)];
    [self dispatchSignal];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)selfRemover
{
    [signal removeListener:self
                    action:_cmd];
}

- (void)testAddingAListenerDuringDispatchShouldNotCallIt
{
    [signal addListener:self
                 action:@selector(addListenerDuringDispatch)];
    [self dispatchSignal];
}

- (void)addListenerDuringDispatch
{
    [signal addListener:self
                 action:@selector(failIfCalled)];
}

- (void)testDispatch2Listeners2ndListenerRemoves1stThen1stListenerIsNotCalled
{
    [signal addListener:self
                 action:@selector(removeFailListener)];
    [signal addListener:self
                 action:@selector(failIfCalled)];
    [self dispatchSignal];
}

- (void)removeFailListener
{
    [signal removeListener:self
                    action:@selector(failIfCalled)];
}

- (void)testAdd2ListenersThenRemoveAllShouldLeaveNoListeners
{
    [signal addListener:self
                 action:@selector(handleCall)];
    [signal addListener:self
                 action:@selector(failIfCalled)];
    [signal removeAll];
    assertThat(signal.head, nilValue());
}

- (void)testRemoveAllDuringDispatchShouldStopAll
{
    [signal addListener:self
                 action:@selector(removeAllListeners)];
    [signal addListener:self
                 action:@selector(failIfCalled)];
    [signal addListener:self
                 action:@selector(handleCall)];
    [self dispatchSignal];
}

- (void)removeAllListeners
{
    [signal removeAll];
}

- (void)testAddOnceListenerThenDispatchShouldCallIt
{
    [super prepare];
    self.currentCall = _cmd;
    [signal addListenerOnce:self
                     action:@selector(handleCall)];
    [self dispatchSignal];

    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}


- (void)testAddOnceListenerShouldBeRemovedAfterDispatch
{
    [signal addListenerOnce:self
                     action:@selector(handleCall)];
    [self dispatchSignal];
    assertThat(signal.head, nilValue());
}

// //// UTILITY METHODS // ////

- (void)dispatchSignal
{
    [signal dispatch];
}

- (void)handleCall
{
    [super notify:kGHUnitWaitStatusSuccess
      forSelector:self.currentCall];
}

- (void)failIfCalled
{
    [super failWithException:[NSException exceptionWithName:@"Failure"
                                                     reason:@"This function should not have been called."
                                                   userInfo:nil]];
}

@end
