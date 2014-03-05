
#import <Foundation/Foundation.h>

@class ASHObjectReflection;

@interface ASHObjectReflectionFactory : NSObject

+ (instancetype)sharedFactory;
- (ASHObjectReflection *)reflection:(NSObject *)component;

@end