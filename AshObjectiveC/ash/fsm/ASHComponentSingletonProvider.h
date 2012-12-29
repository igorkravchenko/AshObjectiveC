
#import <Foundation/Foundation.h>
#import "ASHComponentProvider.h"

@interface ASHComponentSingletonProvider : NSObject <ASHComponentProvider>

- (id)initWithType:(Class)type;

@end
