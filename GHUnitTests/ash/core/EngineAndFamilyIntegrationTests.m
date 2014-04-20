
#import "ASHEngine.h"
#import "MockHelpers.h"
#define HC_SHORTHAND

@interface EngineAndFamilyIntegrationTests : GHAsyncTestCase

@property (nonatomic, strong) ASHEngine * engine;

@end


@implementation EngineAndFamilyIntegrationTests
@synthesize engine;

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
    self.engine = [[ASHEngine alloc] init];
}

- (void)clearEntity
{
    self.engine = nil;
}

- (void)testFamilyIsInitiallyEmpty
{
    ASHNodeList * nodes = [engine getNodeList:[MockNode class]];
    assertThat(nodes.head, nilValue());
}

- (void)testNodeContainsEntityProperties
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    PointComponent * point = [[PointComponent alloc] init];
    MatrixComponent * matrix = [[MatrixComponent alloc] init];
    [entity addComponent:point];
    [entity addComponent:matrix];
    
    ASHNodeList * nodes = [engine getNodeList:[MockNodePointMatrix class]];
    [engine addEntity:entity];
    assertThat([(MockNodePointMatrix *)nodes.head point], sameInstance(point));
    assertThat([(MockNodePointMatrix *)nodes.head matrix], sameInstance(matrix));
}

- (void)testCorrectEntityAddedToFamilyWhenAccessFamilyFirst
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [entity addComponent:[[MatrixComponent alloc] init]];
    ASHNodeList * nodes = [engine getNodeList:[MockNode class]];
    [engine addEntity:entity];
    assertThat(nodes.head.entity, sameInstance(entity));
}

- (void)testCorrectEntityAddedToFamilyWhenComponentsAdded
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [engine addEntity:entity];
    ASHNodeList * nodes = [engine getNodeList:[MockNode class]];
    [entity addComponent:[[PointComponent alloc] init]];
    [entity addComponent:[[MatrixComponent alloc] init]];
    assertThat(nodes.head.entity, sameInstance(entity));
}

- (void)testIncorrectEntityNotAddedToFamilyWhenAccessFamilyFirst
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    ASHNodeList * nodes = [engine getNodeList:[MockNode class]];
    [engine addEntity:entity];
    assertThat(nodes.head, nilValue());
}

- (void)testIncorrectEntityNotAddedToFamilyWhenAccessFamilySecond
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [engine addEntity:entity];
    ASHNodeList * nodes = [engine getNodeList:[MockNode class]];
    assertThat(nodes.head, nilValue());
}

- (void)testEntityRemovedFromFamilyWhenComponentRemovedAndFamilyAlreadyAccessed
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [entity addComponent:[[MatrixComponent alloc] init]];
    [engine addEntity:entity];
    ASHNodeList * nodes = [engine getNodeList:[MockNodePointMatrix class]];
    [entity removeComponent:[PointComponent class]];
    assertThat(nodes.head, nilValue());
}

- (void)testEntityRemovedFromFamilyWhenComponentRemovedAndFamilyNotAlreadyAccessed
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [entity addComponent:[[MatrixComponent alloc] init]];
    [engine addEntity:entity];
    [entity removeComponent:[PointComponent class]];
    ASHNodeList * nodes = [engine getNodeList:[MockNodePointMatrix class]];
    assertThat(nodes.head, nilValue());
}

- (void)testEntityRemovedFromFamilyWhenRemovedFromEngineAndFamilyAlreadyAccessed
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [entity addComponent:[[MatrixComponent alloc] init]];
    [engine addEntity:entity];
    ASHNodeList * nodes = [engine getNodeList:[MockNodePointMatrix class]];
    [engine removeEntity:entity];
    assertThat(nodes.head, nilValue());
}

- (void)testEntityRemovedFromFamilyWhenRemovedFromEngineAndFamilyNotAlreadyAccessed
{
    ASHEntity * entity = [ASHEntity alloc].init;
    [entity addComponent:[[PointComponent alloc] init]];
    [entity addComponent:[[MatrixComponent alloc] init]];
    [engine addEntity:entity];
    [engine removeEntity:entity];
    ASHNodeList * nodes = [engine getNodeList:[MockNodePointMatrix class]];
    assertThat(nodes.head, nilValue());
}

- (void)testFamilyContainsOnlyMatchingEntities
{
    NSMutableArray * entities = [NSMutableArray array];
    for (int i = 0; i < 5; ++i)
    {
        ASHEntity * entity = [[ASHEntity alloc] init];
        [entity addComponent:[[PointComponent alloc] init]];
        [entity addComponent:[[MatrixComponent alloc] init]];
        [entities addObject:entity];
        [engine addEntity:entity];
    }

    ASHNodeList * nodes = [engine getNodeList:[MockNodePointMatrix class]];
    MockNodePointMatrix * node = nil;

    for (node = (MockNodePointMatrix *)nodes.head;
         node != nil;
         node = (MockNodePointMatrix *)node.next)
    {
        assertThat(entities, hasItem(node.entity));
    }
}

- (void)testFamilyContainsAllMatchingEntities
{
    NSMutableArray * entities = [NSMutableArray array];
    for (int i = 0; i < 5; ++i)
    {
        ASHEntity * entity = [[ASHEntity alloc] init];
        [entity addComponent:[[PointComponent alloc] init]];
        [entity addComponent:[[MatrixComponent alloc] init]];
        [entities addObject:entity];
        [engine addEntity:entity];
    }

    ASHNodeList * nodes = [engine getNodeList:[MockNodePointMatrix class]];
    MockNodePointMatrix * node = nil;
    for (node = (MockNodePointMatrix *)nodes.head;
         node != nil;
         node = (MockNodePointMatrix *)node.next)
    {
         [entities removeObject:node.entity];
    }

    assertThat(entities, isEmpty());
}

- (void)testReleaseFamilyEmptiesNodeList
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [entity addComponent:[[MatrixComponent alloc] init]];
    [engine addEntity:entity];
    ASHNodeList * nodes = [engine getNodeList:[MockNodePointMatrix class]];
    [engine releaseNodeList:[MockNodePointMatrix class]];
    assertThat(nodes.head, nilValue());
}

- (void)testReleaseFamilySetsNextNodeToNull
{
    NSMutableArray * entities = [NSMutableArray array];
    for (int i = 0; i < 5; ++i)
    {
        ASHEntity * entity = [[ASHEntity alloc] init];
        [entity addComponent:[[PointComponent alloc] init]];
        [entity addComponent:[[MatrixComponent alloc] init]];
        [entities addObject:entity];
        [engine addEntity:entity];
    }
    ASHNodeList * nodes = [engine getNodeList:[MockNodePointMatrix class]];
    MockNodePointMatrix * node = (MockNodePointMatrix *)nodes.head.next;
    [engine releaseNodeList:[MockNodePointMatrix class]];
    assertThat(node.next, nilValue());
}

- (void)testRemoveAllEntitiesDoesWhatItSays
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [entity addComponent:[[MatrixComponent alloc] init]];
    [engine addEntity:entity];
    entity = [[ASHEntity alloc] init];
    [entity addComponent:[PointComponent alloc].init];
    [entity addComponent:[MatrixComponent alloc].init];
    [engine addEntity:entity];
    ASHNodeList * nodes = [engine getNodeList:[MockNodePointMatrix class]];
    [engine removeAllEntities];
    assertThat(nodes.head, nilValue());
}

@end
