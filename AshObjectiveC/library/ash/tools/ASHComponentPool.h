
#import <Foundation/Foundation.h>

@interface ASHComponentPool : NSObject

+ (instancetype)sharedPool;
- (id)getComponent:(Class)componentClass;
- (void)disposeComponent:(id)component;
- (void)empty;

@end
