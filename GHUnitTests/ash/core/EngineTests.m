
#import <GHUnitIOS/GHUnit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "ASHEngine.h"
#import "ASHFamily.h"
#import "MockHelpers.h"

@interface EngineTests : GHTestCase

@property (nonatomic, strong) ASHEngine * engine;

@end

@implementation EngineTests
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
    engine.familyClass = [MockFamily class];
    [MockFamily reset];
}

- (void)clearEngine
{
    self.engine = nil;
}

- (void)testEntitiesGetterReturnsAllTheEntities
{
    ASHEntity * entity1 = [[ASHEntity alloc] init];
    [engine addEntity:entity1];
    ASHEntity * entity2 = [[ASHEntity alloc] init];
    [engine addEntity:entity2];
    assertThatUnsignedInt(engine.allEntities.count, equalToUnsignedInteger(2));
    assertThat(engine.allEntities, hasItems(entity1, entity2, nil));
}

- (void)testAddEntityChecksWithAllFamilies
{
    [engine getNodeList:[MockNode class]];
    [engine getNodeList:[MockNode2 class]];
    ASHEntity * entity = [[ASHEntity alloc] init];
    [engine addEntity:entity];
    assertThatUnsignedInt([MockFamily.instances[0] newEntityCalls], equalToUnsignedInteger(1));
    assertThatUnsignedInt([MockFamily.instances[1] newEntityCalls], equalToUnsignedInteger(1));
}

- (void)testRemoveEntityChecksWithAllFamilies
{
    [engine getNodeList:[MockNode class]];
    [engine getNodeList:[MockNode2 class]];
    ASHEntity * entity = [[ASHEntity alloc] init];
    [engine addEntity:entity];
    [engine removeEntity:entity];
    assertThatUnsignedInteger([MockFamily.instances[0] removeEntityCalls], equalToUnsignedInteger(1));
    assertThatUnsignedInteger([MockFamily.instances[1] removeEntityCalls], equalToUnsignedInteger(1));
}

- (void)testRemoveAllEntitiesChecksWithAllFamilies
{
    [engine getNodeList:[MockNode class]];
    [engine getNodeList:[MockNode2 class]];
    ASHEntity * entity = [[ASHEntity alloc] init];
    ASHEntity * entity2 = [[ASHEntity alloc] init];
    [engine addEntity:entity];
    [engine addEntity:entity2];
    [engine removeAllEntities];
    assertThatUnsignedInteger([MockFamily.instances[0] removeEntityCalls], equalToUnsignedInteger(2));
    assertThatUnsignedInteger([MockFamily.instances[1] removeEntityCalls], equalToUnsignedInteger(2));
}

- (void)testComponentAddedChecksWithAllFamilies
{
    [engine getNodeList:[MockNode class]];
    [engine getNodeList:[MockNode2 class]];
    ASHEntity * entity = [[ASHEntity alloc] init];
    [engine addEntity:entity];
    [entity addComponent:[[PointComponent alloc] init]];
    assertThatUnsignedInteger([MockFamily.instances[0] componentAddedCalls], equalToUnsignedInteger(1));
    assertThatUnsignedInteger([MockFamily.instances[1] componentAddedCalls], equalToUnsignedInteger(1));
}

- (void)testComponentRemovedChecksWithAllFamilies
{
    [engine getNodeList:[MockNode class]];
    [engine getNodeList:[MockNode2 class]];
    ASHEntity * entity = [[ASHEntity alloc] init];
    [engine addEntity:entity];
    [entity addComponent:[[PointComponent alloc] init]];
    [entity removeComponent:[PointComponent class]];
    assertThatUnsignedInteger([MockFamily.instances[0] componentAddedCalls], equalToUnsignedInteger(1));
    assertThatUnsignedInteger([MockFamily.instances[1] componentAddedCalls], equalToUnsignedInteger(1));
}
                               
- (void)testGetNodeListCreatesFamily
{
    [engine getNodeList:[MockNode class]];
    assertThatUnsignedInteger(MockFamily.instances.count, equalToUnsignedInteger(1));
}
                               
- (void)testGetNodeListChecksAllEntities
{
    [engine addEntity:[[ASHEntity alloc] init]];
    [engine addEntity:[[ASHEntity alloc] init]];
    [engine getNodeList:[MockNode class]];
    assertThatUnsignedInteger([MockFamily.instances[0] newEntityCalls], equalToUnsignedInteger(2));
}
                               
- (void)testReleaseNodeListCallsCleanUp
{
    [engine getNodeList:[MockNode class]];
    [engine releaseNodeList:[MockNode class]];
    assertThatUnsignedInteger([MockFamily.instances[0] cleanUpCalls], equalToUnsignedInteger(1));
}

@end
