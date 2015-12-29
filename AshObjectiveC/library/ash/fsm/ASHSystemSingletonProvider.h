
#import <Foundation/Foundation.h>
#import "ASHSystemProvider.h"

@interface ASHSystemSingletonProvider : NSObject <ASHSystemProvider>

- (instancetype __nonnull)initWithComponentType:(Class __nonnull)componentType;

@end