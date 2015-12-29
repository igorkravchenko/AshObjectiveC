
#import <Foundation/Foundation.h>

@class ASHSystem;

@protocol ASHSystemProvider <NSObject>

- (ASHSystem * __nonnull)getSystem;
- (id __nonnull)identifier;
- (NSInteger)priority;
- (void)setPriority:(NSInteger)value;

@end