
#import <GHUnitIOS/GHUnit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "ASHEntity.h"
#import "MockHelpers.h"

@interface EntityTests : GHAsyncTestCase

@property (nonatomic, strong) ASHEntity * entity;

@end


@implementation EntityTests
@synthesize entity;

- (void)setUp
{
    [self createEntity];
}

- (void)tearDown
{
    [self clearEntity];
}

- (void)createEntity
{
    self.entity = [[ASHEntity alloc] init];
}

- (void)clearEntity
{
    self.entity = nil;
}

- (void)testAddReturnsReferenceToEntity
{
    MockComponent * component = [[MockComponent alloc] init];
    ASHEntity * e = [entity addComponent:component];
    assertThat(e, sameInstance(entity));
}

- (void)testCanStoreAndRetrieveComponent
{
    MockComponent * component = [[MockComponent alloc] init];
    [entity addComponent:component];
    assertThat([entity getComponent:[MockComponent class]], sameInstance(component));
}

- (void)testCanStoreAndRetrieveMultipleComponents
{
    MockComponent * component1 = [[MockComponent alloc] init];
    [entity addComponent:component1];
    MockComponent2 * component2 = [[MockComponent2 alloc] init];
    [entity addComponent:component2];
    assertThat([entity getComponent:[MockComponent class]], sameInstance(component1));
    assertThat([entity getComponent:[MockComponent2 class]], sameInstance(component2));
}

- (void)testCanReplaceComponent
{
    MockComponent * component1 = [[MockComponent alloc] init];
    [entity addComponent:component1];
    MockComponent * component2 = [[MockComponent alloc] init];
    [entity addComponent:component2];
    assertThat([entity getComponent:[MockComponent class]], sameInstance(component2));
}

- (void)testCanStoreBaseAndExtendedComponents
{
    MockComponent * component1 = [[MockComponent alloc] init];
    [entity addComponent:component1];
    MockComponentExtended * component2 = [[MockComponentExtended alloc] init];
    [entity addComponent:component2];
    assertThat([entity getComponent:[MockComponent class]], sameInstance(component1));
    assertThat([entity getComponent:[MockComponentExtended class]], sameInstance(component2));
}

- (void)testCanStoreExtendedComponentAsBaseType
{
    MockComponentExtended * component = [[MockComponentExtended alloc] init];
    [entity addComponent:component componentClass:[MockComponent class]];
    assertThat([entity getComponent:[MockComponent class]], sameInstance(component));
}

- (void)testGetReturnNullIfNoComponent
{
    assertThat([entity getComponent:[MockComponent class]], nilValue());
}

- (void)testWillRetrieveAllComponents
{
    MockComponent * component1 = [[MockComponent alloc] init];
    [entity addComponent:component1];
    MockComponent2 * component2 = [[MockComponent2 alloc] init];
    [entity addComponent:component2];
    NSArray * all = [entity allComponents];
    assertThatUnsignedInteger(all.count, equalToUnsignedInteger(2));
    assertThat(all, hasItems(component1, component2, nil));
}

- (void)testHasComponentIsFalseIfComponentTypeNotPresent
{
    [entity addComponent:[[MockComponent2 alloc] init]];
    assertThatBool([entity hasComponent:[MockComponent class]], equalToBool(NO));
}

- (void)testHasComponentIsTrueIfComponentTypeIsPresent
{
    [entity addComponent:[[MockComponent alloc] init]];
    assertThatBool([entity hasComponent:[MockComponent class]], equalToBool(YES));
}

- (void)testCanRemoveComponent
{
    MockComponent * component = [[MockComponent alloc] init];
    [entity addComponent:component];
    [entity removeComponent:[MockComponent class]];
    assertThatBool([entity hasComponent:[MockComponent class]], equalToBool(NO));
}

- (void)testStoringComponentTriggersAddedSignal
{
    [super prepare];
    
     MockComponent * component = [[MockComponent alloc] init];
    
    [entity.componentAdded addListener:self
                                action:
     
     @selector(callbackStoringComponentTriggersAddedSignal:componentClass:)];
    
     [entity addComponent:component];
    
     [super waitForStatus:kGHUnitWaitStatusSuccess
                  timeout:kCallbackTimout];
     
}

- (void)callbackStoringComponentTriggersAddedSignal:(ASHEntity *)entity
                                      componentClass:(Class)componentClass
{    
     [super notify:kGHUnitWaitStatusSuccess
      forSelector:@selector(testStoringComponentTriggersAddedSignal)];
}

- (void)testRemovingComponentTriggersRemovedSignal
{
    [super prepare];

    MockComponent * mockComponent = [[MockComponent alloc] init];
    [entity addComponent:mockComponent];

    [entity.componentRemoved addListener:self
                                action:@selector(callbackRemovingComponentTriggersRemovedSignal:componentClass:)];
    [entity removeComponent:[MockComponent class]];
    
    [super waitForStatus:kGHUnitWaitStatusSuccess
                timeout:kCallbackTimout];
}

- (void)callbackRemovingComponentTriggersRemovedSignal:(ASHEntity *)entity
                                        componentClass:(Class)componentClass
{
    [super notify:kGHUnitWaitStatusSuccess
      forSelector:@selector(testRemovingComponentTriggersRemovedSignal)];
}

- (void)testComponentAddedSignalContainsCorrectParameters
{
    [super prepare];
    
    MockComponent * component = [[MockComponent alloc] init];
    [entity.componentAdded addListener:self
                                action:@selector(callbackComponentAddedSignalContainsCorrectParameters:componentClass:)];
    [entity addComponent:component];
    
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)callbackComponentAddedSignalContainsCorrectParameters:(ASHEntity *)anEntity
                                               componentClass:(Class)componentClass
{
    [self doTestSignalContent:anEntity
               componentClass:componentClass];
    [super notify:kGHUnitWaitStatusSuccess
      forSelector:@selector(testComponentAddedSignalContainsCorrectParameters)];
}

- (void)testComponentRemovedSignalContainsCorrectParameters
{
    [super prepare];
    
    MockComponent * component = [[MockComponent alloc] init];
    [entity addComponent:component];
    [entity.componentRemoved addListener:self
                                  action:@selector(callbackComponentRemovedSignalContainsCorrectParameters:componentClass:)];
    [entity removeComponent:[MockComponent class]];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)callbackComponentRemovedSignalContainsCorrectParameters:(ASHEntity *)anEntity
                                                 componentClass:(Class)componentClass
{
    [self doTestSignalContent:anEntity
               componentClass:componentClass];
    [super notify:kGHUnitWaitStatusSuccess
      forSelector:@selector(testComponentRemovedSignalContainsCorrectParameters)];
}

- (void)doTestSignalContent:(ASHEntity *)signalEntity
             componentClass:(Class)componentClass
{
    assertThat(signalEntity, sameInstance(entity));
    assertThat(componentClass, sameInstance([MockComponent class]));
}

@end
