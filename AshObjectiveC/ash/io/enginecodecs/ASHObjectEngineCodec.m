
#import "ASHObjectEngineCodec.h"
#import "ASHEngineEncoder.h"
#import "ASHEngineDecoder.h"
#import "ASHCodecManager.h"
#import "ASHSignal1.h"
#import "ASHEngine.h"

@implementation ASHObjectEngineCodec
{
    ASHEngineEncoder * _encoder;
    ASHEngineDecoder * _decoder;
    ASHCodecManager * _codecManager;
    ASHSignal1 * _encodeCompleteSignal;
    ASHSignal1 * _decodeCompleteSignal;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _codecManager = [[ASHCodecManager alloc] init];
        _encoder = [[ASHEngineEncoder alloc] init];
        _decoder = [[ASHEngineDecoder alloc] init];
        _encodeCompleteSignal = [[ASHSignal1 alloc] init];
        _decodeCompleteSignal = [[ASHSignal1 alloc] init];
    }

    return self;
}

- (void)addCustomCodec:(id <ASHObjectCodec>)codec
                 types:(NSArray *)types
{
    for (NSString * typeString in types)
    {
        [_codecManager addCustomCodec:codec
                                 type:NSClassFromString(typeString)];
    }

}

- (id)encodeEngine:(ASHEngine *)engine
{
    [_encoder reset];
    NSDictionary * encoded = [_encoder encodeEngine:engine];
    [_encodeCompleteSignal dispatchWithObject:encoded];
    return encoded;
}

- (void)decodeEngine:(id)encodedData
              engine:(ASHEngine *)engine;
{
    [_decoder reset];
    [_decoder decodeEngine:encodedData
                    engine:engine];
    [_decodeCompleteSignal dispatchWithObject:engine];
}

- (void)decodeOverEngine:(id)encodedData
                  engine:(ASHEngine *)engine
{
    [_decoder reset];
    [_decoder decodeOverEngine:encodedData
                        engine:engine];
    [_decodeCompleteSignal dispatchWithObject:engine];
}

- (ASHSignal1 *)encodeComplete
{
    return _encodeCompleteSignal;
}

- (ASHSignal1 *)decodeComplete
{
    return _decodeCompleteSignal;
}

@end