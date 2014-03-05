
#import <Foundation/Foundation.h>

@class ASHCodecManager;

@protocol ASHObjectCodec <NSObject>

- (NSDictionary *)encode:(NSObject *)object
            codecManager:(ASHCodecManager *)codecManager;
- (NSObject *)decode:(NSDictionary *)object
        codecManager:(ASHCodecManager *)codecManager;
- (void)decodeIntoObject:(NSObject *)target
                  object:(NSDictionary *)object
            codecManager:(ASHCodecManager *)codecManager;
- (void)decodeIntoProperty:(NSObject *)parent
                  property:(NSString *)property
                    object:(NSDictionary *)object
              codecManager:(ASHCodecManager *)codecManager;

@end