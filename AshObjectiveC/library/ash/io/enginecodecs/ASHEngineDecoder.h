
#import <Foundation/Foundation.h>

@class ASHCodecManager;
@class ASHEngine;

@interface ASHEngineDecoder : NSObject

- (instancetype)initWithCodecManager:(ASHCodecManager *)codecManager;

- (void)reset;

- (void)decodeEngine:(NSDictionary *)encodedData
              engine:(ASHEngine *)engine;

- (void)decodeOverEngine:(NSDictionary *)encodedData
                  engine:(ASHEngine *)engine;
@end