
#import <Foundation/Foundation.h>
#import "ASHSystemProvider.h"

@interface ASHSystemInstanceProvider : NSObject <ASHSystemProvider>

- (instancetype)initWithInstance:(ASHSystem *)instance;

@end