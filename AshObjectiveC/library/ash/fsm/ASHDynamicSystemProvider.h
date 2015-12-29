
#import <Foundation/Foundation.h>
#import "ASHSystemProvider.h"

@interface ASHDynamicSystemProvider : NSObject <ASHSystemProvider>

- (instancetype __nonnull)initWithTarget:(id __nonnull)target
                        method:(SEL __nonnull)method;

@end