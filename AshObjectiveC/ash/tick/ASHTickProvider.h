
#import <Foundation/Foundation.h>

@protocol ASHTickProvider <NSObject>

- (void)addListener:(id)target
             action:(SEL)action;

- (void)removeListener:(id)target
                action:(SEL)action;

- (void)start;
- (void)stop;

@end
