
#import <Foundation/Foundation.h>

@interface MockPoint : NSObject

@property (nonatomic, readwrite) CGFloat x;
@property (nonatomic, readwrite) CGFloat y;

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y;

+ (instancetype)pointWithX:(CGFloat)x y:(CGFloat)y;


@end