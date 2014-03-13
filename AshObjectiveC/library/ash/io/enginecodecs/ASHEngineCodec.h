
#import <Foundation/Foundation.h>

@protocol ASHObjectCodec;
@class ASHEngine;
@class ASHSignal1;

@protocol ASHEngineCodec <NSObject>

- (void)addCustomCodec:(id <ASHObjectCodec>)codec
                 types:(NSArray *)types;
- (id)encodeEngine:(ASHEngine *)engine;
- (void)decodeEngine:(id)encodedData
              engine:(ASHEngine *)engine;
- (void)decodeOverEngine:(id)encodedData
                  engine:(ASHEngine *)engine;

@property (nonatomic, readonly) ASHSignal1 * encodeComplete;
@property (nonatomic, readonly) ASHSignal1 * decodeComplete;

@end