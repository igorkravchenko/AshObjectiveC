
#import <Foundation/Foundation.h>

@class ASHCodecManager;
@class ASHEngine;

static NSString * const entitiesKey = @"entities";
static NSString * const componentsKey = @"components";
static NSString * const nameKey = @"name";
static NSString * const idKey = @"id";

@interface ASHEngineEncoder : NSObject
- (instancetype)initWithCodecManager:(ASHCodecManager *)codecManager;

- (void)reset;

- (NSDictionary *)encodeEngine:(ASHEngine *)engine;
@end