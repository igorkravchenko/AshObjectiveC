
#import <GHUnitIOS/GHUnit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "MockHelpers.h"
#import "ASHEngine.h"
#import "ASHListIteratingSystem.h"

@interface ListIteratingSystemTest : GHTestCase

@property (nonatomic, strong) NSArray * entities;
@property (nonatomic, assign) NSInteger callCount;

@end

@implementation ListIteratingSystemTest

@synthesize entities;
@synthesize callCount;

- (void)testUpdateIteratesOverNodes
{
    ASHEngine * engine = [[ASHEngine alloc] init];
    ASHEntity * entity1 = [[ASHEntity alloc] init];
    PointComponent * component1 = [[PointComponent alloc] init];
    [entity1 addComponent:component1];
    [engine addEntity:entity1];
    ASHEntity * entity2 = [[ASHEntity alloc] init];
    PointComponent * component2 = [[PointComponent alloc] init];
    [entity2 addComponent:component2];
    [engine addEntity:entity2];
    ASHEntity * entity3 = [[ASHEntity alloc] init];
    PointComponent * component3 = [[PointComponent alloc] init];
    [entity3 addComponent:component3];
    [engine addEntity:entity3];
    
    ASHListIteratingSystem * system = [[ASHListIteratingSystem alloc]
initWithNodeClass:[MockNode class]
 nodeUpdateTarget:self
nodeUpdateSelector:@selector(updateNode:time:)];
    [engine addSystem:system
             priority:1];
    self.entities = @[entity1, entity2, entity3];
    callCount = 0;
    [engine update:0.1];
    assertThatUnsignedInteger(callCount, equalToUnsignedInteger(3));
}

- (void)updateNode:(MockNode *)node
              time:(NSNumber *)time
{
    assertThat(node.entity, equalTo(entities[callCount]));
    assertThat(time, equalTo(@(0.1)));
    callCount++;
}

@end
