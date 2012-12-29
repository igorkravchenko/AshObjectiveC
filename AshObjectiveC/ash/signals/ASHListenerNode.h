
#import <Foundation/Foundation.h>
@interface ASHListenerNode : NSObject

@property (nonatomic, weak) ASHListenerNode * previous;
@property (nonatomic, strong) ASHListenerNode * next;
@property (nonatomic, assign) SEL listener;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) BOOL once;

@end
