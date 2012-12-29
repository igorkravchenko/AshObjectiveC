
#import <GHUnitIOS/GHUnit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "ASHEngine.h"
#import "ASHComponentMatchingFamily.h"
#import "MockHelpers.h"

@interface ComponentMatchingFamilyTests : GHTestCase

@property (nonatomic, strong) ASHEngine * engine;
@property (nonatomic, strong) ASHComponentMatchingFamily * family;

@end

@implementation ComponentMatchingFamilyTests
@synthesize engine;
@synthesize family;

- (void)setUp
{
    [self createFamily];
}

- (void)tearDown
{
    [self clearFamily];
}

- (void)createFamily
{
    self.engine = [[ASHEngine alloc] init];
    self.family = [[ASHComponentMatchingFamily alloc] initWithNodeClass:[MockNode class]
                                                         engine:engine];
}

- (void)clearFamily
{
    self.engine = nil;
    self.family = nil;
}

- (void)testNodeListIsInitiallyEmpty
{
    ASHNodeList * nodes = family.nodeList;
    assertThat(nodes.head, nilValue());
}

- (void)testMatchingEntityIsAddedWhenAccessNodeListFirst
{
    ASHNodeList * nodes = family.nodeList;
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [family newEntity:entity];
    assertThat(nodes.head.entity, sameInstance(entity));
}

- (void)testMatchingEntityIsAddedWhenAccessNodeListSecond
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [family newEntity:entity];
    ASHNodeList * nodes = family.nodeList;
    assertThat(nodes.head.entity, sameInstance(entity));
}

- (void)testNodeContainsEntityProperties
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    PointComponent * point = [[PointComponent alloc] init];
    [entity addComponent:point];
    [family newEntity:entity];
    ASHNodeList * nodes = family.nodeList;
    assertThat([(MockNode *)nodes.head point], sameInstance(point));
}

- (void)testMatchingEntityIsAddedWhenComponentAdded
{
    ASHNodeList * nodes = family.nodeList;
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [family componentAddedToEntity:entity
                    componentClass:[PointComponent class]];
    assertThat(nodes.head.entity, sameInstance(entity));
}

- (void)testNonMatchingEntityIsNotAdded
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [family newEntity:entity];
    ASHNodeList * nodes = family.nodeList;
    assertThat(nodes.head, nilValue());
}

- (void)testNonMatchingEntityIsNotAddedWhenComponentAdded
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[MatrixComponent alloc] init]];
    [family componentAddedToEntity:entity
                    componentClass:[MatrixComponent class]];
    ASHNodeList * nodes = family.nodeList;
    assertThat(nodes.head, nilValue());
}

- (void)testEntityIsRemovedWhenAccessNodeListFirst
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [family newEntity:entity];
    ASHNodeList * nodes = family.nodeList;
    [family removeEntity:entity];
    assertThat(nodes.head, nilValue());
}

- (void)testEntityIsRemovedWhenAccessNodeListSecond
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [family newEntity:entity];
    [family removeEntity:entity];
    ASHNodeList * nodes = family.nodeList;
    assertThat(nodes.head, nilValue());
}

- (void)testEntityIsRemovedWhenComponentRemoved
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [family newEntity:entity];
    [entity removeComponent:[PointComponent class]];
    [family componentRemovedFromEntity:entity
                        componentClass:[PointComponent class]];
    ASHNodeList * nodes = family.nodeList;
    assertThat(nodes.head, nilValue());
}

- (void)testNodeListContainsOnlyMatchingEntities
{
    NSMutableArray * entities = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; ++i)
    {
        ASHEntity * entity = [[ASHEntity alloc] init];
        [entity addComponent:[[PointComponent alloc] init]];
        [entities addObject:entity];
        [family newEntity:entity];
        [family newEntity:[[ASHEntity alloc] init]];
    }
    
    ASHNodeList * nodes = family.nodeList;
    MockNode * node = nil;
    for (node = (MockNode *)nodes.head; node != nil; node = (MockNode *)node.next)
    {
        assertThat(entities, hasItem(node.entity));
    }
}

- (void)testNodeListContainsAllMatchingEntities
{
    NSMutableArray * entities = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; ++i)
    {
        ASHEntity * entity = [[ASHEntity alloc] init];
        [entity addComponent:[[PointComponent alloc] init]];
        [entities addObject:entity];
        [family newEntity:entity];
        [family newEntity:[[ASHEntity alloc] init]];
    }
    
    ASHNodeList * nodes = family.nodeList;
    MockNode * node = nil;
    for (node = (MockNode *)nodes.head; node != nil; node = (MockNode *)node.next)
    {
        NSUInteger i = [entities indexOfObject:node.entity];
        [entities removeObjectAtIndex:i];
    }
    assertThat(entities, empty());
}

- (void)testCleanUpEmptiesNodeList
{
    ASHEntity * entity = [[ASHEntity alloc] init];
    [entity addComponent:[[PointComponent alloc] init]];
    [family newEntity:entity];
    ASHNodeList * nodes = family.nodeList;
    [family cleanUp];
    assertThat(nodes.head, nilValue());
}

- (void)testCleanUpSetsNextNodeToNull
{
    NSMutableArray * entities = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; ++i)
    {
        ASHEntity * entity = [[ASHEntity alloc] init];
        [entity addComponent:[[PointComponent alloc] init]];
        [entities addObject:entity];
        [family newEntity:entity];
    }
    ASHNodeList * nodes = family.nodeList;
    MockNode * node = (MockNode *)nodes.head.next;
    [family cleanUp];
    assertThat(node.next, nilValue());
}

@end