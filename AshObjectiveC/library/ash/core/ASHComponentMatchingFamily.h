
#import <Foundation/Foundation.h>
#import "ASHNodeList.h"
#import "ASHEngine.h"
#import "ASHFamily.h"

@interface ASHComponentMatchingFamily : NSObject <ASHFamily>

- (id)initWithNodeClass:(Class)nodeClass 
                         engine:(ASHEngine *)game;

@end
