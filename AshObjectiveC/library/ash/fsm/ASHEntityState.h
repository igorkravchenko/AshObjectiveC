
#import <Foundation/Foundation.h>
#import "ASHComponentProvider.h"

@class ASHStateComponentMapping;

@interface ASHEntityState : NSObject

@property (nonnull, nonatomic, readonly) NSMapTable * providers;

- (ASHStateComponentMapping * __nonnull)add:(Class __nonnull)type;
- (id <ASHComponentProvider> __nonnull)get:(Class __nonnull)type;
- (BOOL)has:(Class __nonnull)type;

@end
