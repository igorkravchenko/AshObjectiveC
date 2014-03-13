
#import <Foundation/Foundation.h>
#import "ASHSystemProvider.h"

@interface ASHDynamicSystemProvider : NSObject <ASHSystemProvider>

- (instancetype)initWithTarget:(id)target
                        method:(SEL)method;

@end