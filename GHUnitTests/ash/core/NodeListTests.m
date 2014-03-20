
#import <GHUnitIOS/GHUnit.h>
#import "MockHelpers.h"
#import "NodeListMatcher.h"

@interface NodeListTests : GHAsyncTestCase

@property (nonatomic, strong) ASHNodeList * nodes;
@property (nonatomic, strong) ASHNode * tempNode;

@end

@implementation NodeListTests
@synthesize nodes;
@synthesize tempNode;

- (void)setUp
{
    [self createNodeList];
}

- (void)tearDown
{
    [self clearNodeList];
}

- (void)createNodeList
{
    self.nodes = [[ASHNodeList alloc] init];
}

- (void)clearNodeList
{
    self.nodes = nil;
}

- (void)testAddingNodeTriggersAddedSignal
{
    [super prepare];
    MockNode * node = [[MockNode alloc] init];
    [nodes.nodeAdded addListener:self
                          action:@selector(callbackAddingNodeTriggersAddedSignal:componentClass:)];
    [nodes addNode:node];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)callbackAddingNodeTriggersAddedSignal:(ASHEntity *)entity
                               componentClass:(Class)componentClass
{
    [super notify:kGHUnitWaitStatusSuccess
      forSelector:@selector(testAddingNodeTriggersAddedSignal)];
}

- (void)testRemovingNodeTriggersRemovedSignal
{
    [super prepare];
    MockNode * node = [[MockNode alloc] init];
    [nodes addNode:node];
    [nodes.nodeRemoved addListener:self
                            action:@selector(callbackRemovingNodeTriggersRemovedSignal:componentClass:)];
    [nodes removeNode:node];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)callbackRemovingNodeTriggersRemovedSignal:(ASHEntity *)entity
                                   componentClass:(Class)componentClass
{
    [super notify:kGHUnitWaitStatusSuccess
      forSelector:@selector(testRemovingNodeTriggersRemovedSignal)];
}

- (void)testAllNodesAreCoveredDuringIteration
{
    NSMutableArray * nodeArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; ++i)
    {
        MockNode * node = [[MockNode alloc] init];
        [nodeArray addObject:node];
        [nodes addNode:node];
    }
    
    MockNode * node = nil;
    for (node = (MockNode *)nodes.head; node != nil; node = (MockNode *)node.next)
    {
        [nodeArray removeObject:node];
    }
    assertThat(nodeArray, isEmpty());
}

- (void)testRemovingCurrentNodeDuringIterationIsValid
{
    NSMutableArray * nodeArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; ++i)
    {
        MockNode * node = [[MockNode alloc] init];
        [nodeArray addObject:node];
        [nodes addNode:node];
    }
    
    NSInteger count = 0;
    MockNode * node = nil;
    for (node = (MockNode *)nodes.head; node != nil; node = (MockNode *)node.next)
    {
        [nodeArray removeObject:node];
        if (++count == 2)
        {
            [nodes removeNode:node];
        }
    }
    assertThat(nodeArray, isEmpty());
}

- (void)testRemovingNextNodeDuringIterationIsValid
{
    NSMutableArray * nodeArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; ++i)
    {
        MockNode * node = [[MockNode alloc] init];
        [nodeArray addObject:node];
        [nodes addNode:node];
    }
    
    NSInteger count = 0;
    MockNode * node = nil;
    for (node = (MockNode *)nodes.head; node != nil; node = (MockNode *)node.next)
    {
        [nodeArray removeObject:node];
        if (++count == 2)
        {
            [nodes removeNode:node.next];
        }
    }
    assertThatUnsignedInteger(nodeArray.count, equalToUnsignedInteger(1));
}

- (void)testComponentAddedSignalContainsCorrectParameters
{
    [super prepare];
    self.tempNode = [[ASHNode alloc] init];
    [nodes.nodeAdded addListener:self
                          action:@selector(callbackComponentAddedSignalContainsCorrectParameters:)];
    [nodes addNode:tempNode];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)callbackComponentAddedSignalContainsCorrectParameters:(ASHNode *)node
{
    [self doTestSignalContent:node];
    [super notify:kGHUnitWaitStatusSuccess
      forSelector:@selector(testComponentAddedSignalContainsCorrectParameters)];
}

- (void)testComponentRemovedSignalContainsCorrectParameters
{
    [super prepare];
    self.tempNode = [[MockNode alloc] init];
    [nodes addNode:tempNode];
    [nodes.nodeRemoved addListener:self
                            action:@selector(callbackComponentRemovedSignalContainsCorrectParameters:)];
    [nodes removeNode:tempNode];
    [super waitForStatus:kGHUnitWaitStatusSuccess
                 timeout:kCallbackTimout];
}

- (void)callbackComponentRemovedSignalContainsCorrectParameters:(ASHNode *)node
{
    [self doTestSignalContent:node];
    [super notify:kGHUnitWaitStatusSuccess
      forSelector:@selector(testComponentRemovedSignalContainsCorrectParameters)];
}

- (void)doTestSignalContent:(ASHNode *)signalNode
{
    assertThat(signalNode, sameInstance(tempNode));
}

- (void)testNodesInitiallySortedInOrderOfAddition
{
    ASHNode * node1 = [[MockNode alloc] init];
    ASHNode * node2 = [[MockNode alloc] init];
    ASHNode * node3 = [[MockNode alloc] init];
    [nodes addNode:node1];
    [nodes addNode:node2];
    [nodes addNode:node3];
    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node2, node3, nil];
    assertThat(nodes, matcher);
}

- (void)testSwappingOnlyTwoNodesChangesTheirOrder
{
    MockNode * node1 = [[MockNode alloc] init];
    MockNode * node2 = [[MockNode alloc] init];
    [nodes addNode:node1];
    [nodes addNode:node2];
    [nodes swapNode:node1 node:node2];
    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node2, node1, nil];
    assertThat(nodes, matcher);
}

- (void)testSwappingAdjacentNodesChangesTheirPositions
{
    MockNode * node1 = [[MockNode alloc] init];
    MockNode * node2 = [[MockNode alloc] init];
    MockNode * node3 = [[MockNode alloc] init];
    MockNode * node4 = [[MockNode alloc] init];
    [nodes addNode:node1];
    [nodes addNode:node2];
    [nodes addNode:node3];
    [nodes addNode:node4];
    [nodes swapNode:node2
               node:node3];
    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node3, node2, node4, nil];
    assertThat(nodes, matcher);
}

- (void)testSwappingNonAdjacentNodesChangesTheirPositions
{
    MockNode * node1 = [[MockNode alloc] init];
    MockNode * node2 = [[MockNode alloc] init];
    MockNode * node3 = [[MockNode alloc] init];
    MockNode * node4 = [[MockNode alloc] init];
    MockNode * node5 = [[MockNode alloc] init];
    [nodes addNode:node1];
    [nodes addNode:node2];
    [nodes addNode:node3];
    [nodes addNode:node4];
    [nodes addNode:node5];
    [nodes swapNode:node2
               node:node4];
    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node4, node3, node2, node5, nil];
    assertThat(nodes, matcher);
}

- (void)testSwappingEndNodesChangesTheirPositions
{
    MockNode * node1 = [[MockNode alloc] init];
    MockNode * node2 = [[MockNode alloc] init];
    MockNode * node3 = [[MockNode alloc] init];
    [nodes addNode:node1];
    [nodes addNode:node2];
    [nodes addNode:node3];
    [nodes swapNode:node1
               node:node3];
    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node3, node2, node1, nil];
    assertThat(nodes, matcher);
}

- (void)testInsertionSortCorrectlySortsSortedNodes
{
    MockNodeSort * node1 = [[MockNodeSort alloc] init];
    node1.pos = 1;
    MockNodeSort * node2 = [[MockNodeSort alloc] init];
    node2.pos = 2;
    MockNodeSort * node3 = [[MockNodeSort alloc] init];
    node3.pos = 3;
    MockNodeSort * node4 = [[MockNodeSort alloc] init];
    node4.pos = 4;

    [nodes addNode:node1];
    [nodes addNode:node2];
    [nodes addNode:node3];
    [nodes addNode:node4];

    __block NodeListTests * weakSelf = self;

    [nodes insertionSortUsingBlock:^float(ASHNode *nodeA, ASHNode *nodeB)
    {
        return [weakSelf sortNode1:(MockNodeSort *)nodeA
                             node2:(MockNodeSort *)nodeB];
    }];

    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node2, node3, node4, nil];
    assertThat(nodes, matcher);
}

- (void)testInsertionSortCorrectlySortsReversedNodes
{
    MockNodeSort * node1 = [[MockNodeSort alloc] init];
    node1.pos = 1;
    MockNodeSort * node2 = [[MockNodeSort alloc] init];
    node2.pos = 2;
    MockNodeSort * node3 = [[MockNodeSort alloc] init];
    node3.pos = 3;
    MockNodeSort * node4 = [[MockNodeSort alloc] init];
    node4.pos = 4;

    [nodes addNode:node4];
    [nodes addNode:node3];
    [nodes addNode:node2];
    [nodes addNode:node1];

    __block NodeListTests * weakSelf = self;

    [nodes insertionSortUsingBlock:^float(ASHNode *nodeA, ASHNode *nodeB)
    {
        return [weakSelf sortNode1:(MockNodeSort *)nodeA
                             node2:(MockNodeSort *)nodeB];
    }];

    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node2, node3, node4, nil];
    assertThat(nodes, matcher);
}

- (void)testInsertionSortCorrectlySortsMixedNodes
{
    MockNodeSort * node1 = [[MockNodeSort alloc] init];
    node1.pos = 1;
    MockNodeSort * node2 = [[MockNodeSort alloc] init];
    node2.pos = 2;
    MockNodeSort * node3 = [[MockNodeSort alloc] init];
    node3.pos = 3;
    MockNodeSort * node4 = [[MockNodeSort alloc] init];
    node4.pos = 4;
    MockNodeSort * node5 = [[MockNodeSort alloc] init];
    node5.pos = 5;

    [nodes addNode:node3];
    [nodes addNode:node4];
    [nodes addNode:node1];
    [nodes addNode:node5];
    [nodes addNode:node2];

    __block NodeListTests * weakSelf = self;

    [nodes insertionSortUsingBlock:^float(ASHNode *nodeA, ASHNode *nodeB)
    {
        return [weakSelf sortNode1:(MockNodeSort *)nodeA
                             node2:(MockNodeSort *)nodeB];
    }];

    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node2, node3, node4, node5, nil];
    assertThat(nodes, matcher);
}

- (void)testInsertionSortRetainsTheOrderOfEquivalentNodes
{
    MockNodeSort * node1 = [[MockNodeSort alloc] init];
    node1.pos = 1;
    MockNodeSort * node2 = [[MockNodeSort alloc] init];
    node2.pos = 2;
    MockNodeSort * node3 = [[MockNodeSort alloc] init];
    node3.pos = 3;
    MockNodeSort * node4 = [[MockNodeSort alloc] init];
    node4.pos = 4;
    MockNodeSort * node5 = [[MockNodeSort alloc] init];
    node5.pos = 4;

    [nodes addNode:node3];
    [nodes addNode:node4];
    [nodes addNode:node1];
    [nodes addNode:node5];
    [nodes addNode:node2];

    __block NodeListTests * weakSelf = self;

    [nodes insertionSortUsingBlock:^float(ASHNode *nodeA, ASHNode *nodeB)
    {
        return [weakSelf sortNode1:(MockNodeSort *)nodeA
                             node2:(MockNodeSort *)nodeB];
    }];

    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node2, node3, node4, node5, nil];
    assertThat(nodes, matcher);
}

- (void)testMergeSortCorrectlySortsSortedNodes
{
    MockNodeSort * node1 = [[MockNodeSort alloc] init];
    node1.pos = 1;
    MockNodeSort * node2 = [[MockNodeSort alloc] init];
    node2.pos = 2;
    MockNodeSort * node3 = [[MockNodeSort alloc] init];
    node3.pos = 3;
    MockNodeSort * node4 = [[MockNodeSort alloc] init];
    node4.pos = 4;

    [nodes addNode:node1];
    [nodes addNode:node2];
    [nodes addNode:node3];
    [nodes addNode:node4];

    __block NodeListTests * weakSelf = self;
    [nodes mergeSortUsingBlock:^float(ASHNode *nodeA, ASHNode *nodeB)
    {
        return [weakSelf sortNode1:(MockNodeSort *)nodeA
                             node2:(MockNodeSort *)nodeB];
    }];

    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node2, node3, node4, nil];
    assertThat(nodes, matcher);
}

- (void)testMergeSortCorrectlySortsReversedNodes
{
    MockNodeSort * node1 = [[MockNodeSort alloc] init];
    node1.pos = 1;
    MockNodeSort * node2 = [[MockNodeSort alloc] init];
    node2.pos = 2;
    MockNodeSort * node3 = [[MockNodeSort alloc] init];
    node3.pos = 3;
    MockNodeSort * node4 = [[MockNodeSort alloc] init];
    node4.pos = 4;

    [nodes addNode:node3];
    [nodes addNode:node4];
    [nodes addNode:node1];
    [nodes addNode:node2];

    __block NodeListTests * weakSelf = self;
    [nodes mergeSortUsingBlock:^float(ASHNode *nodeA, ASHNode *nodeB)
    {
        return [weakSelf sortNode1:(MockNodeSort *)nodeA
                             node2:(MockNodeSort *)nodeB];
    }];

    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node2, node3, node4, nil];
    assertThat(nodes, matcher);
}

- (void)testMergeSortCorrectlySortsMixedNodes
{
    MockNodeSort * node1 = [[MockNodeSort alloc] init];
    node1.pos = 1;
    MockNodeSort * node2 = [[MockNodeSort alloc] init];
    node2.pos = 2;
    MockNodeSort * node3 = [[MockNodeSort alloc] init];
    node3.pos = 3;
    MockNodeSort * node4 = [[MockNodeSort alloc] init];
    node4.pos = 4;
    MockNodeSort * node5 = [[MockNodeSort alloc] init];
    node5.pos = 5;

    [nodes addNode:node3];
    [nodes addNode:node4];
    [nodes addNode:node1];
    [nodes addNode:node5];
    [nodes addNode:node2];

    __block NodeListTests * weakSelf = self;

    [nodes insertionSortUsingBlock:^float(ASHNode *nodeA, ASHNode *nodeB)
    {
        return [weakSelf sortNode1:(MockNodeSort *)nodeA
                             node2:(MockNodeSort *)nodeB];
    }];

    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node2, node3, node4, node5, nil];
    assertThat(nodes, matcher);
}

- (void)testMergeSortRetainsTheOrderOfEquivalentNodes
{
    MockNodeSort * node1 = [[MockNodeSort alloc] init];
    node1.pos = 1;
    MockNodeSort * node2 = [[MockNodeSort alloc] init];
    node2.pos = 2;
    MockNodeSort * node3 = [[MockNodeSort alloc] init];
    node3.pos = 3;
    MockNodeSort * node4 = [[MockNodeSort alloc] init];
    node4.pos = 4;
    MockNodeSort * node5 = [[MockNodeSort alloc] init];
    node5.pos = 4;

    [nodes addNode:node3];
    [nodes addNode:node4];
    [nodes addNode:node1];
    [nodes addNode:node5];
    [nodes addNode:node2];

    __block NodeListTests * weakSelf = self;

    [nodes mergeSortUsingBlock:^float(ASHNode *nodeA, ASHNode *nodeB)
    {
        return [weakSelf sortNode1:(MockNodeSort *)nodeA
                             node2:(MockNodeSort *)nodeB];
    }];

    HCBaseMatcher * matcher = [NodeListMatcher nodeList:node1, node2, node3, node4, node5, nil];
    assertThat(nodes, matcher);
}


- (float)sortNode1:(MockNodeSort *)node1
             node2:(MockNodeSort *)node2
{
    return node1.pos - node2.pos;
}

@end
