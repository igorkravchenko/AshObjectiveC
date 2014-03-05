#import <objc/message.h>
#import "ASHNativeObjectCodec.h"

static NSString * const typeKey = @"type";
static NSString * const valueKey = @"value";

@implementation ASHNativeObjectCodec
{

}

- (NSDictionary *)encode:(NSObject *)object
            codecManager:(ASHCodecManager *)codecManager
{

    return @{
                typeKey : NSStringFromClass(object.class),
                valueKey : object
    };
}

- (NSObject *)decode:(NSDictionary *)object
        codecManager:(ASHCodecManager *)codecManager
{
    return object[valueKey];
}

- (void)decodeIntoObject:(NSObject *)target
                  object:(NSDictionary *)object
            codecManager:(ASHCodecManager *)codecManager
{
    @throw [NSException exceptionWithName:@"ASHNativeObjectCodecException"
                                   reason:@"Can't decode into a native object because the object is passed by value, not by reference, so we're decoding into a local copy not the original."
                                 userInfo:nil];
}

- (void)decodeIntoProperty:(NSObject *)parent
                  property:(NSString *)property
                    object:(NSDictionary *)object
              codecManager:(ASHCodecManager *)codecManager
{
    [parent setValue:object[valueKey]
              forKey:property];

}


@end