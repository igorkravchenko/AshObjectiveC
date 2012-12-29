
#import <Foundation/Foundation.h>
#import "ASHNodeList.h"
#import "ASHEngine.h"
#import "ASHFamily.h"

@interface ASHComponentMatchingFamily : NSObject <ASHFamily>

@property (nonatomic, weak) ASHComponentMatchingFamily * previous;
@property (nonatomic, strong) ASHComponentMatchingFamily * next;
@property (nonatomic, strong) NSMutableDictionary * entities;

- (id)initWithNodeClass:(Class)nodeClass 
                         engine:(ASHEngine *)game;

@end
