
#import <Foundation/Foundation.h>
#import "ASHComponentProvider.h"

@interface ASHDynamicComponentProvider : NSObject <ASHComponentProvider>

- (id)initWithTarget:(id)target
             closure:(SEL)closure;

@end