
#import <Foundation/Foundation.h>
#import "ASHListenerNode.h"

@interface ASHSignalBase : NSObject

@property (nonatomic, strong) ASHListenerNode * head;
@property (nonatomic, strong) ASHListenerNode * tail;
@property (nonatomic, readonly) NSUInteger numListeners;

- (void)startDispatch;
- (void)endDispatch;

- (void)addListener:(id)target 
             action:(SEL)action;

- (void)addListenerOnce:(id)target 
                 action:(SEL)action;

- (void)addNode:(ASHListenerNode *)node;

- (void)removeListener:(id)target 
                action:(SEL)action;

- (void)removeAll;

@end
