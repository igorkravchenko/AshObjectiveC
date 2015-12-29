
#import <Foundation/Foundation.h>
#import "ASHComponentProvider.h"

@interface ASHComponentSingletonProvider : NSObject <ASHComponentProvider>

- (instancetype __nonnull)initWithType:(Class __nonnull)type;

@end
