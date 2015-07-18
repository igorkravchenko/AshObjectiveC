
#import <Foundation/Foundation.h>
#import "ASHNodeList.h"
#import "ASHEngine.h"
#import "ASHFamily.h"

@interface ASHComponentMatchingFamily : NSObject <ASHFamily>

@property (nonatomic, strong) NSMutableDictionary * entities;

- (id)initWithNodeClass:(Class)nodeClass 
                         engine:(ASHEngine *)game;

@end
