
#import <Foundation/Foundation.h>
#import "ASHComponentInstanceProvider.h"

@interface ASHComponentTypeProvider : NSObject <ASHComponentProvider>

- (id)initWithType:(Class)type;

@end
