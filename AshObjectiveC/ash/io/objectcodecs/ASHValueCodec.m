#import <objc/message.h>
#import "ASHValueCodec.h"
#import "ASHCodecManager.h"
#import "ASHTypeAssociations.h"

typedef NSString * (^ASHValueEncodeBlock)(NSValue * value);
typedef NSValue * (^ASHValueDecodeBlock)(NSDictionary * encodedValue);

@implementation ASHValueCodec
{
    NSMutableDictionary *_encodeBlocks;
    NSMutableDictionary *_decodeBlocks;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _encodeBlocks = [NSMutableDictionary dictionary];
        _decodeBlocks = [NSMutableDictionary dictionary];
        NSString * cgPointObjCType = @"{CGPoint=ff}";
        NSString * cgRectObjCType = @"{CGRect={CGPoint=ff}{CGSize=ff}}";

        [self addEncodeBlock:^NSString *(NSValue *value)
        {
            return NSStringFromCGPoint([value CGPointValue]);
        }        forObjCType:cgPointObjCType];

        [self addDecodeBlock:^NSValue *(NSDictionary *encodedValue)
        {
            return [NSValue valueWithCGPoint:CGPointFromString(encodedValue[valueKey])];
        } forObjCType:cgPointObjCType];





    }

    return self;
}

- (void)addEncodeBlock:(ASHValueEncodeBlock)encodeBlock
           forObjCType:(NSString *)objCType
{
    _encodeBlocks[objCType] = [encodeBlock copy];
}

- (void)addDecodeBlock:(ASHValueDecodeBlock)decodeBlock
           forObjCType:(NSString *)objCType
{
    _decodeBlocks[objCType] = [decodeBlock copy];
}



- (NSDictionary *)encode:(id)object
            codecManager:(ASHCodecManager *)codecManager
{
    NSValue * value = object;
    NSString * objCType = @(value.objCType);
    ASHTypeAssociations * associations = [ASHTypeAssociations instance];

    ASHValueEncodeBlock encodeBlock = _encodeBlocks[objCType];
    if(encodeBlock)
    {
        NSDictionary * encoded = @{typeKey: [associations associationForType:value.class], objCTypeKey : objCType, valueKey: encodeBlock(value)};
        return encoded;
    }

    return @{typeKey: [associations associationForType:value.class], objCTypeKey : objCType, valueKey: [NSNull null]};
}

- (NSObject *)decode:(NSDictionary *)object codecManager:(ASHCodecManager *)codecManager
{
    NSString * objCType = object[objCTypeKey];

    ASHValueDecodeBlock decodeBlock = _decodeBlocks[objCType];

    if(decodeBlock)
    {
        return decodeBlock(object);
    }

    return nil;
}

- (void)decodeIntoObject:(NSObject *)target object:(NSDictionary *)object codecManager:(ASHCodecManager *)codecManager
{

}

- (void)decodeIntoProperty:(NSObject *)parent property:(NSString *)property object:(NSDictionary *)object codecManager:(ASHCodecManager *)codecManager
{

}


@end