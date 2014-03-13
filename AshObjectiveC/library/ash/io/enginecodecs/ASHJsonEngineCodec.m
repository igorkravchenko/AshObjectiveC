
#import "ASHJsonEngineCodec.h"
#import "ASHEngine.h"

@implementation ASHJsonEngineCodec
{

}

- (id)encodeEngine:(ASHEngine *)engine
{

    id object = [super encodeEngine:engine];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    return [[NSString alloc] initWithData:jsonData
                                 encoding:NSUTF8StringEncoding];

}

- (void)decodeEngine:(id)encodedData
              engine:(ASHEngine *)engine
{
    NSData * data = [encodedData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0
                                                  error:&error];
    [super decodeEngine:object
                 engine:engine];
}

- (void)decodeOverEngine:(id)encodedData
                  engine:(ASHEngine *)engine
{
    NSData * data = [encodedData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0
                                                  error:&error];
    [super decodeOverEngine:object
                     engine:engine];
}


@end