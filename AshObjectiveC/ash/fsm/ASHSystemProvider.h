
#import <Foundation/Foundation.h>

@class ASHSystem;

@protocol ASHSystemProvider <NSObject>

- (ASHSystem *)getSystem;
- (id)identifier;
- (NSInteger)priority;
- (void)setPriority:(NSInteger)value;

@end