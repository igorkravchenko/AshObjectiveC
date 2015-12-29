
#import <Foundation/Foundation.h>
#import "ASHSystemProvider.h"

@interface ASHSystemInstanceProvider : NSObject <ASHSystemProvider>

- (instancetype __nonnull)initWithInstance:(ASHSystem * __nonnull)instance;

@end