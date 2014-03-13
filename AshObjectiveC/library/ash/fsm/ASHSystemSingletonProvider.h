
#import <Foundation/Foundation.h>
#import "ASHSystemProvider.h"

@interface ASHSystemSingletonProvider : NSObject <ASHSystemProvider>

- (instancetype)initWithComponentType:(Class)componentType;

@end