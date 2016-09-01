
#import <Foundation/Foundation.h>
#import "ASHNodeList.h"
#import "ASHEngine.h"
#import "ASHFamily.h"

@interface ASHComponentMatchingFamily : NSObject <ASHFamily>

- (instancetype __nonnull)initWithNodeClass:(Class __nonnull)nodeClass
                           engine:(ASHEngine * __nonnull)game;

@end
