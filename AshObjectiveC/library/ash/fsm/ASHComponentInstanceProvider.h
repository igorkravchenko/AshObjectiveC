
#import <Foundation/Foundation.h>
#import "ASHComponentProvider.h"

@interface ASHComponentInstanceProvider : NSObject <ASHComponentProvider>

- (instancetype __nonnull)initWithInstance:(id __nonnull)instance;

@end
