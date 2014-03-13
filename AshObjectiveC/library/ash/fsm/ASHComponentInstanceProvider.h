
#import <Foundation/Foundation.h>
#import "ASHComponentProvider.h"

@interface ASHComponentInstanceProvider : NSObject <ASHComponentProvider>

- (id)initWithInstance:(id)instance;

@end
