
#import <Foundation/Foundation.h>

@interface ASHCodecManager : NSObject

- (id <ASHObjectCodec>)getCodecForComponent:(NSObject *)component;

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