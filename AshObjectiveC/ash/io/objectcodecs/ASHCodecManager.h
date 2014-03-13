
#import <Foundation/Foundation.h>

@protocol ASHObjectCodec;

@interface ASHCodecManager : NSObject

- (id <ASHObjectCodec>)getCodecForObject:(id)object;

- (id <ASHObjectCodec>)getCodecForComponent:(id)component;

- (void)addCustomCodec:(id <ASHObjectCodec>)codec
                  type:(Class)type;

- (NSDictionary *)encodeComponent:(NSObject *)object;

- (NSDictionary *)encodeObject:(NSObject *)object;

- (NSObject *)decodeComponent:(NSDictionary *)object;

- (NSObject *)decodeObject:(NSDictionary *)object;

- (void)decodeIntoComponent:(NSObject *)target
                     object:(NSDictionary *)encoded;

- (void)decodeIntoProperty:(NSObject *)parent
                  property:(NSString *)property
                    object:(NSDictionary *)object;

@end