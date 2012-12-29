
#import <Foundation/Foundation.h>

@interface ASHComponentPool : NSObject

+ (id)sharedInstance;
- (id)getComponent:(Class)componentClass;
- (void)disposeComponent:(id)component;
- (void)empty;

@end
