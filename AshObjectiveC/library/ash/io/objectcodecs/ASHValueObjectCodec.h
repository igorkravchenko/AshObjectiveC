
#import <Foundation/Foundation.h>
#import "ASHObjectCodec.h"

typedef NSString * (^ASHValueEncodeBlock)(NSValue * value);
typedef NSValue * (^ASHValueDecodeBlock)(NSDictionary * encodedValue);

@interface ASHValueObjectCodec : NSObject <ASHObjectCodec>

- (void)addEncodeBlock:(ASHValueEncodeBlock)encodeBlock forObjCType:(NSString *)objCType;
- (void)addDecodeBlock:(ASHValueDecodeBlock)decodeBlock forObjCType:(NSString *)objCType;

@end