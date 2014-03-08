
#import <Foundation/Foundation.h>

@interface MockComponent2IO : NSObject

@property (nonatomic, readwrite) NSInteger x;
@property (nonatomic, readwrite) NSInteger y;

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y;

@end