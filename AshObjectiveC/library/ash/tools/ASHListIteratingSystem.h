
#import "ASHSystem.h"
#import "ASHNodeList.h"

@interface ASHListIteratingSystem : ASHSystem

@property (nonatomic, weak) ASHNodeList * nodeList;
@property (nonatomic, assign) Class nodeClass;
@property (nonatomic, weak) id nodeUpdateTarget;
@property (nonatomic, assign) SEL nodeUpdateSelector;
@property (nonatomic, weak) id nodeAddedTarget;
@property (nonatomic, assign) SEL nodeAddedSelector;
@property (nonatomic, weak) id nodeRemovedTarget;
@property (nonatomic, assign) SEL nodeRemovedSelector;

- (id)initWithNodeClass:(Class)nodeClass 
       nodeUpdateTarget:(id)nodeUpdateTarget 
     nodeUpdateSelector:(SEL)nodeUpdateSelector
        nodeAddedTarget:(id)nodeAddedTarget
      nodeAddedSelector:(SEL)nodeAddedSelector
      nodeRemovedTarget:(id)nodeRemovedTarget
    nodeRemovedSelector:(SEL)nodeRemovedSelector;

- (id)initWithNodeClass:(Class)nodeClass 
       nodeUpdateTarget:(id)nodeUpdateTarget 
     nodeUpdateSelector:(SEL)nodeUpdateSelector;

// in this case target is self
- (id)initWithNodeClass:(Class)nodeClass
     nodeUpdateSelector:(SEL)nodeUpdateSelector;

- (id)initWithNodeClass:(Class)nodeClass
     nodeUpdateSelector:(SEL)nodeUpdateSelector
      nodeAddedSelector:(SEL)nodeAddedSelector
    nodeRemovedSelector:(SEL)nodeRemovedSelector;

@end
