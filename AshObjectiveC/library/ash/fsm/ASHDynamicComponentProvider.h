
#import <Foundation/Foundation.h>
#import "ASHComponentProvider.h"

@interface ASHDynamicComponentProvider : NSObject <ASHComponentProvider>

- (instancetype __nonnull)initWithTarget:(id __nonnull)target
             closure:(SEL __nonnull)closure;

@end