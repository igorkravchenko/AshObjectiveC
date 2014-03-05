
#import <Foundation/Foundation.h>

@class ASHCodecManager;
@class ASHEngine;

@interface ASHEngineEncoder : NSObject
- (instancetype)initWithCodecManager:(ASHCodecManager *)codecManager;

- (void)reset;

- (NSDictionary *)encodeEngine:(ASHEngine *)engine;
@end