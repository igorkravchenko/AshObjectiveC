
#import <Foundation/Foundation.h>

static NSString * const typeKey = @"type";
static NSString * const valueKey = @"value";
static NSString * const valuesKey = @"values";
static NSString * const propertiesKey = @"properties";
static NSString * const classKey = @"Class";
static NSString * const objCTypeKey = @"objCType";

@class ASHCodecManager;

@protocol ASHObjectCodec <NSObject>

- (NSDictionary *)encode:(id)object
            codecManager:(ASHCodecManager *)codecManager;
- (id)decode:(NSDictionary *)object
codecManager:(ASHCodecManager *)codecManager;
- (void)decodeIntoObject:(NSObject *)target
                  object:(NSDictionary *)object
            codecManager:(ASHCodecManager *)codecManager;
- (void)decodeIntoProperty:(NSObject *)parent
                  property:(NSString *)property
                    object:(NSDictionary *)object
              codecManager:(ASHCodecManager *)codecManager;

@end