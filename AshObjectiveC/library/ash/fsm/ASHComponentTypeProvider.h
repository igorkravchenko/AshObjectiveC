
#import <Foundation/Foundation.h>
#import "ASHComponentInstanceProvider.h"

@interface ASHComponentTypeProvider : NSObject <ASHComponentProvider>

- (instancetype __nonnull)initWithType:(Class __nonnull)type;

@end
