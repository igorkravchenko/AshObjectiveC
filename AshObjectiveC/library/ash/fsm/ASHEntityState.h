
#import <Foundation/Foundation.h>
#import "ASHComponentProvider.h"

@class ASHStateComponentMapping;

@interface ASHEntityState : NSObject

@property (nonatomic, strong) NSMutableDictionary * providers;

- (ASHStateComponentMapping *)add:(Class)type;
- (id <ASHComponentProvider>)get:(Class)type;
- (BOOL)has:(Class)type;

@end
